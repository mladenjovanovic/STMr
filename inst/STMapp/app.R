library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(STM)
library(plotly)

# Extension for the DT
js <- c(
  "table.on('key', function(e, datatable, key, cell, originalEvent){",
  "  var targetName = originalEvent.target.localName;",
  "  if(key == 13 && targetName == 'body'){",
  "    $(cell.node()).trigger('dblclick.dt');",
  "  }",
  "});",
  "table.on('keydown', function(e){",
  "  if(e.target.localName == 'input' && [9,13,37,38,39,40].indexOf(e.keyCode) > -1){",
  "    $(e.target).trigger('blur');",
  "  }",
  "});"
)

# For potly
hline <- function(y = 0, color = "grey") {
  list(
    type = "line",
    x0 = 0,
    x1 = 1,
    xref = "paper",
    y0 = y,
    y1 = y,
    line = list(color = color, dash = "dot")
  )
}

vline <- function(x = 0, color = "grey") {
  list(
    type = "line",
    y0 = 0,
    y1 = 1,
    yref = "paper",
    x0 = x,
    x1 = x,
    line = list(color = color, dash = "dot")
  )
}

RMSE <- function(model) {
  sqrt(mean(resid(model)^2))
}

# Max absolute error
maxErr <- function(model) {
  residuals <- resid(model)

  residuals[[which.max(abs(residuals))]]
}
#################################################
# UI
#################################################
ui <- dashboardPage(
  dashboardHeader(title = "STMapp"),

  # Sidebar items
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Entry", tabName = "data_entry_menu_item", icon = icon("dumbbell")),
      menuItem("Progression Tables", tabName = "progression_tables_menu_item", icon = icon("table")),
      menuItem("Schemes", tabName = "schemes_menu_item", icon = icon("signal"))
    ) # sidebarMenu
  ), # DashboardSidebar

  # Body
  dashboardBody(
    fluidPage(
      tabItems(
        # ================================
        tabItem(
          tabName = "data_entry_menu_item",
          column(
            6,
            box(
              title = "Known 1RM",
              id = "data_entry_known_1RM",
              collapsible = TRUE,
              width = 12,
              numericInput("data_entry_known_1RM_value", label = "1RM", value = 150, min = 0, max = 1000, step = 1),
              br(),
              DTOutput("data_entry_known_1RM_table"),
              br(),
              actionButton("data_entry_known_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start"))
            ), # Box Known 1RM
            box(
              title = "Model using reps (nRM) as target",
              id = "model_known_1RM_estimates",
              collapsible = TRUE,
              width = 12,
              dataTableOutput("model_known_1RM_estimates_table"),
              br(),
              plotlyOutput("model_known_1RM_plot")
            ), # Known 1RM estimates
            box(
              title = "Model using reps (nRM) as predictor",
              id = "model_known_1RM_estimates_reverse",
              collapsible = TRUE,
              width = 12,
              dataTableOutput("model_known_1RM_estimates_table_reverse"),
              br(),
              plotlyOutput("model_known_1RM_plot_reverse")
            ), # Known 1RM estimates REVERSE
          ), # Column
          column(
            6,
            box(
              title = "Estimate 1RM",
              id = "data_entry_estimate_1RM",
              collapsible = TRUE,
              width = 12,
              DTOutput("data_entry_estimate_1RM_table"),
              br(),
              actionButton("data_entry_estimate_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start"))
            ), # Box Estimate 1RM
            box(
              title = "Model using reps (nRM) as target",
              id = "model_estimate_1RM_estimates",
              collapsible = TRUE,
              width = 12,
              dataTableOutput("model_estimate_1RM_estimates_table"),
              br(),
              selectInput(
                "model_estimate_1RM_plot_type",
                label = "Plot",
                choices = c("Weight", "Estimated %1RMs")
              ),
              plotlyOutput("model_estimate_1RM_plot")
            ), # Estimate 1RM estimates
            box(
              title = "Model using reps (nRM) as predictor",
              id = "model_estimate_1RM_estimates_reverse",
              collapsible = TRUE,
              width = 12,
              dataTableOutput("model_estimate_1RM_estimates_table_reverse"),
              br(),
              selectInput(
                "model_estimate_1RM_plot_type_reverse",
                label = "Plot",
                choices = c("Weight", "Estimated %1RMs")
              ),
              plotlyOutput("model_estimate_1RM_plot_reverse")
            ) # Estimate 1RM estimates REVERSE
          ) # Column
        ), # Data Entry Tab
        tabItem(
          tabName = "progression_tables_menu_item",
          box(
            title = "Settings",
            id = "settings_progression_tables",
            collapsible = TRUE,
            width = 12,
            h4("Select model you want to utilize"),
            # br(),
            column(
              4,
              selectInput(
                "settings_data",
                label = "Data from:",
                choices = c("Known 1RM", "Unknown 1RM")
              )
            ),
            column(
              4,
              selectInput(
                "settings_model",
                label = "Model:",
                choices = c("Epley's", "Modified Epley's", "Linear"),
                selected = 2
              )
            ),
            column(
              4,
              selectInput(
                "settings_model_type",
                label = "Type:",
                choices = c("nRM as Target variable", "nRM sa Predictor variable")
              )
            ),
            br(),
            h4("Select progression table to be utilize"),
            column(
              6,
              selectInput(
                "settings_progression_table",
                label = "Progression table:",
                choices = c(
                  "Deducted Intensity 2.5%",
                  "Deducted Intensity 5%",
                  "Relative Intensity",
                  "Perc Drop",
                  "RIR 1",
                  "RIR 2",
                  "RIR Inc",
                  "%MR Step Const",
                  "%MR Step Var"
                ),
                selected = "RIR Inc"
              )
            ),
            column(
              6,
              selectInput(
                "settings_progression_table_type",
                label = "Table type:",
                choices = c(
                  "Grinding",
                  "Ballistic"
                )
              )
            )
          ), # Settings box
          box(
            title = "Reps-Max Table",
            id = "reps_max_table",
            collapsible = TRUE,
            width = 12,
            dataTableOutput("reps_max_table")
          ), # Reps max table
          box(
            title = "Progression Table (%1RM)",
            id = "progression_table",
            collapsible = TRUE,
            width = 12,
            # Estimated %1RMS
            column(
              4,
              h5("Intensive variant"),
              dataTableOutput("progression_table_intensive_perc1RM")
            ),
            column(
              4,
              h5("Normal variant"),
              dataTableOutput("progression_table_normal_perc1RM")
            ),
            column(
              4,
              h5("Extensive variant"),
              dataTableOutput("progression_table_extensive_perc1RM")
            ), # Estimated %1RMS
          ),
          box(
            title = "Progression Table (Adjustments)",
            id = "progression_table",
            collapsible = TRUE,
            width = 12,
            # Estimated Adjustments
            column(
              4,
              h5("Intensive variant"),
              dataTableOutput("progression_table_intensive_adjustment")
            ),
            column(
              4,
              h5("Normal variant"),
              dataTableOutput("progression_table_normal_adjustment")
            ),
            column(
              4,
              h5("Extensive variant"),
              dataTableOutput("progression_table_extensive_adjustment")
            ), # Estimated Adjustments
          ), # Progression table
          box(
            title = "Example set and rep schemes",
            id = "example_schemes_table",
            collapsible = TRUE,
            width = 12,
            dataTableOutput("progression_table_example_scheme")
          ), # Reps max table
        ), # Progression tables
        tabItem(
          tabName = "schemes_menu_item"
        ) # Schemes
      ) # tabItems
    ) # FluidPage
  ) # Dashboard Body
)

#################################################
# SERVER
#################################################
server <- function(input, output) {

  # Known 1RM entry table
  known_1RM_table <- reactiveValues(data = {
    tibble(Weight = numeric(0), Reps = numeric(0), eRIR = numeric(0)) %>%
      add_row(
        Weight = c(135, 120, 105, NA, NA),
        Reps = c(3, 8, 12, NA, NA),
        eRIR = c(0, 0, 0, NA, NA)
      )
  })

  output$data_entry_known_1RM_table <- renderDT({
    DT::datatable(
      known_1RM_table$data,
      rownames = FALSE, selection = "none",
      editable = list(
        target = "cell",
        # disable = list(columns = c(1)),
        numeric = c(1, 2)
      ),
      callback = JS(js),
      extensions = "KeyTable",
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE,
        keys = TRUE
      )
    )
  })

  observeEvent(input$data_entry_known_1RM_table_cell_edit, {
    # get values
    info <- input$data_entry_known_1RM_table_cell_edit
    i <- as.numeric(info$row)
    j <- as.numeric(info$col) + 1
    k <- as.numeric(info$value)

    # write values to reactive
    known_1RM_table$data[i, j] <- k
  })

  # ========================
  # Estimate 1RM entry table
  estimate_1RM_table <- reactiveValues(data = {
    data.frame(Weight = numeric(0), Reps = numeric(0), eRIR = numeric(0)) %>%
      add_row(
        Weight = c(135, 120, 105, NA, NA),
        Reps = c(3, 8, 12, NA, NA),
        eRIR = c(0, 0, 0, NA, NA)
      )
  })

  output$data_entry_estimate_1RM_table <- renderDT({
    DT::datatable(
      estimate_1RM_table$data,
      rownames = FALSE, selection = "none",
      editable = list(
        target = "cell",
        # disable = list(columns = c(1)),
        numeric = c(1, 2)
      ),
      callback = JS(js),
      extensions = "KeyTable",
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE,
        keys = TRUE
      )
    )
  })

  observeEvent(input$data_entry_estimate_1RM_table_cell_edit, {
    # get values
    info <- input$data_entry_estimate_1RM_table_cell_edit
    i <- as.numeric(info$row)
    j <- as.numeric(info$col) + 1
    k <- as.numeric(info$value)

    # write values to reactive
    estimate_1RM_table$data[i, j] <- k
  })

  ###################################
  # Get rep-max profiles
  known_1RM_value <- eventReactive(input$data_entry_known_1RM_button,
    {
      input$data_entry_known_1RM_value
    },
    ignoreNULL = FALSE
  )

  known_1RM_table_react <- eventReactive(input$data_entry_known_1RM_button,
    {
      known_1RM_table$data
    },
    ignoreNULL = FALSE
  )

  known_1RM_models <- eventReactive(input$data_entry_known_1RM_button,
    {
      model_data <- known_1RM_table_react()

      model_data <- na.omit(model_data)

      model_data$perc_1RM <- model_data$Weight / known_1RM_value()
      model_data$nRM <- model_data$Reps + model_data$eRIR

      # Epley's model
      epley <- estimate_k(
        perc_1RM = model_data$perc_1RM,
        reps = model_data$nRM
      )

      # Modified Epley's model
      epley_mod <- estimate_kmod(
        perc_1RM = model_data$perc_1RM,
        reps = model_data$nRM
      )

      # Linear model
      linear <- estimate_klin(
        perc_1RM = model_data$perc_1RM,
        reps = model_data$nRM
      )

      # Epley's model reverse
      epley_reverse <- estimate_k(
        perc_1RM = model_data$perc_1RM,
        reps = model_data$nRM,
        reverse = TRUE
      )

      # Modified Epley's model reverse
      epley_mod_reverse <- estimate_kmod(
        perc_1RM = model_data$perc_1RM,
        reps = model_data$nRM,
        reverse = TRUE
      )

      # Linear model reverse
      linear_reverse <- estimate_klin(
        perc_1RM = model_data$perc_1RM,
        reps = model_data$nRM,
        reverse = TRUE
      )

      # Return
      list(
        epley = epley,
        epley_mod = epley_mod,
        linear = linear,
        epley_reverse = epley_reverse,
        epley_mod_reverse = epley_mod_reverse,
        linear_reverse = linear_reverse
      )
    },
    ignoreNULL = FALSE
  )


  estimate_1RM_table_react <- eventReactive(input$data_entry_estimate_1RM_button,
    {
      estimate_1RM_table$data
    },
    ignoreNULL = FALSE
  )

  estimate_1RM_models <- eventReactive(input$data_entry_estimate_1RM_button,
    {
      model_data <- estimate_1RM_table_react()

      model_data <- na.omit(model_data)

      model_data$nRM <- model_data$Reps + model_data$eRIR

      # Epley's model
      epley <- estimate_k_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM,
        weighted = TRUE
      )

      # Modified Epley's model
      epley_mod <- estimate_kmod_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM,
        weighted = TRUE
      )

      # Linear model
      linear <- estimate_klin_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM,
        weighted = TRUE
      )

      # Epley's model Reverse
      epley_reverse <- estimate_k_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM,
        reverse = TRUE,
        weighted = TRUE
      )

      # Modified Epley's model Reverse
      epley_mod_reverse <- estimate_kmod_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM,
        reverse = TRUE,
        weighted = TRUE
      )

      # Linear model Reverse
      linear_reverse <- estimate_klin_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM,
        reverse = TRUE,
        weighted = TRUE
      )

      # Return
      list(
        epley = epley,
        epley_mod = epley_mod,
        linear = linear,
        epley_reverse = epley_reverse,
        epley_mod_reverse = epley_mod_reverse,
        linear_reverse = linear_reverse
      )
    },
    ignoreNULL = FALSE
  )

  # Model plots
  output$model_known_1RM_plot <- renderPlotly({
    models <- known_1RM_models()

    observed_data <- known_1RM_table_react()

    observed_data <- na.omit(observed_data)

    observed_data$perc_1RM <- 100 * (observed_data$Weight / known_1RM_value())
    observed_data$nRM <- observed_data$Reps + observed_data$eRIR

    # Model predictions
    model_predictions <- data.frame(
      perc_1RM = seq(0.5, 1, length.out = 1000)
    )

    estimated_k <- coef(models$epley)[[1]]
    estimated_kmod <- coef(models$epley_mod)[[1]]
    estimated_klin <- coef(models$linear)[[1]]

    model_predictions <- model_predictions %>%
      mutate(
        epley_nRM = get_max_reps_k(perc_1RM, k = estimated_k),
        epley_mod_nRM = get_max_reps_kmod(perc_1RM, k = estimated_kmod),
        linear_nRM = get_max_reps_klin(perc_1RM, k = estimated_klin),
        weight = perc_1RM * known_1RM_value(),
        perc_1RM = perc_1RM * 100
      )

    gg <- plot_ly() %>%
      add_markers(
        data = observed_data, x = ~perc_1RM, y = ~nRM,
        hoverinfo = "text", opacity = 0.9, marker = list(color = "black"),
        text = ~ paste(
          "Observed data\n",
          paste("Weight =", round(Weight, 2), "\n"),
          paste("%1RM =", round(perc_1RM, 2), "\n"),
          paste("Reps =", round(nRM, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, x = ~perc_1RM, y = ~epley_nRM,
        hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
        text = ~ paste(
          "Epley's model\n",
          paste("Weight =", round(weight, 2), "\n"),
          paste("%1RM =", round(perc_1RM, 2), "\n"),
          paste("Reps =", round(epley_nRM, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, x = ~perc_1RM, y = ~epley_mod_nRM,
        hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
        text = ~ paste(
          "Modified Epley's model\n",
          paste("Weight =", round(weight, 2), "\n"),
          paste("%1RM =", round(perc_1RM, 2), "\n"),
          paste("Reps =", round(epley_mod_nRM, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, x = ~perc_1RM, y = ~linear_nRM,
        hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
        text = ~ paste(
          "Linear model\n",
          paste("Weight =", round(weight, 2), "\n"),
          paste("%1RM =", round(perc_1RM, 2), "\n"),
          paste("Reps =", round(linear_nRM, 2))
        )
      ) %>%
      layout(
        showlegend = FALSE,
        yaxis = list(
          side = "left", title = "Max number of reps",
          showgrid = TRUE, zeroline = TRUE
        ),
        xaxis = list(
          side = "left", title = "%1RM",
          showgrid = TRUE, zeroline = FALSE
        ),
        shapes = list(hline(1), vline(100))
      )

    gg
  })

  output$model_estimate_1RM_plot <- renderPlotly({
    models <- estimate_1RM_models()

    observed_data <- estimate_1RM_table_react()

    observed_data <- na.omit(observed_data)

    observed_data$nRM <- observed_data$Reps + observed_data$eRIR

    # Model predictions
    estimated_k_0RM <- coef(models$epley)[[1]]
    estimated_kmod_1RM <- coef(models$epley_mod)[[1]]
    estimated_klin_1RM <- coef(models$linear)[[1]]

    estimated_k <- coef(models$epley)[[2]]
    estimated_kmod <- coef(models$epley_mod)[[2]]
    estimated_klin <- coef(models$linear)[[2]]

    graph_max_weight <- max(estimated_k_0RM, estimated_kmod_1RM, estimated_klin_1RM)

    graph_min_weight <- graph_max_weight * min(
      get_max_perc_1RM_k(20, k = estimated_k),
      get_max_perc_1RM_kmod(20, k = estimated_kmod),
      get_max_perc_1RM_klin(20, k = estimated_klin)
    )

    observed_data <- observed_data %>%
      mutate(
        epley_nRM = predict(models$epley, newdata = data.frame(weight = Weight)),
        epley_mod_nRM = predict(models$epley_mod, newdata = data.frame(weight = Weight)),
        linear_nRM = predict(models$linear, newdata = data.frame(weight = Weight)),
        epley_perc1RM = 100 * get_max_perc_1RM_k(epley_nRM, k = estimated_k),
        epley_mod_perc1RM = 100 * get_max_perc_1RM_kmod(epley_mod_nRM, kmod = estimated_kmod),
        linear_perc1RM = 100 * get_max_perc_1RM_klin(linear_nRM, klin = estimated_klin)
      )

    model_predictions <- data.frame(
      weight = seq(
        graph_min_weight,
        graph_max_weight,
        length.out = 1000
      )
    )

    model_predictions <- model_predictions %>%
      mutate(
        epley_nRM = predict(models$epley, newdata = data.frame(weight = weight)),
        epley_mod_nRM = predict(models$epley_mod, newdata = data.frame(weight = weight)),
        linear_nRM = predict(models$linear, newdata = data.frame(weight = weight)),
        epley_perc1RM = 100 * get_max_perc_1RM_k(epley_nRM, k = estimated_k),
        epley_mod_perc1RM = 100 * get_max_perc_1RM_kmod(epley_mod_nRM, kmod = estimated_kmod),
        linear_perc1RM = 100 * get_max_perc_1RM_klin(linear_nRM, klin = estimated_klin)
      )

    if (input$model_estimate_1RM_plot_type == "Weight") {
      gg <- plot_ly() %>%
        add_markers(
          data = observed_data, x = ~Weight, y = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "black"),
          text = ~ paste(
            "Observed data\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("Epley's %1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Modified Epley's %1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Linear %1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~weight, y = ~epley_nRM,
          hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
          text = ~ paste(
            "Epley's model\n",
            paste("Weight =", round(weight, 2), "\n"),
            paste("%1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Reps =", round(epley_nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~weight, y = ~epley_mod_nRM,
          hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
          text = ~ paste(
            "Modified Epley's model\n",
            paste("Weight =", round(weight, 2), "\n"),
            paste("%1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(epley_mod_nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~weight, y = ~linear_nRM,
          hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
          text = ~ paste(
            "Linear model\n",
            paste("Weight =", round(weight, 2), "\n"),
            paste("%1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(linear_nRM, 2))
          )
        ) %>%
        layout(
          showlegend = FALSE,
          yaxis = list(
            side = "left", title = "Max number of reps",
            showgrid = TRUE, zeroline = TRUE
          ),
          xaxis = list(
            side = "left", title = "Weight",
            showgrid = TRUE, zeroline = FALSE
          ),
          shapes = list(hline(1))
        )
    } else {
      gg <- plot_ly() %>%
        add_markers(
          data = observed_data, x = ~epley_perc1RM, y = ~epley_nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#FAA43A"),
          text = ~ paste(
            "Epley's prediction\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("%1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Reps =", round(epley_nRM, 2))
          )
        ) %>%
        add_markers(
          data = observed_data, x = ~epley_mod_perc1RM, y = ~epley_mod_nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#5DA5DA"),
          text = ~ paste(
            "Modified Epley's prediction\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("%1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(epley_mod_nRM, 2))
          )
        ) %>%
        add_markers(
          data = observed_data, x = ~linear_perc1RM, y = ~linear_nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#60BD68"),
          text = ~ paste(
            "Linear prediction\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("%1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(linear_nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~epley_perc1RM, y = ~epley_nRM,
          hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
          text = ~ paste(
            "Epley's model\n",
            paste("Weight =", round(weight, 2), "\n"),
            paste("%1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Reps =", round(epley_nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~epley_mod_perc1RM, y = ~epley_mod_nRM,
          hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
          text = ~ paste(
            "Modified Epley's model\n",
            paste("Weight =", round(weight, 2), "\n"),
            paste("%1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(epley_mod_nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~linear_perc1RM, y = ~linear_nRM,
          hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
          text = ~ paste(
            "Linear model\n",
            paste("Weight =", round(weight, 2), "\n"),
            paste("%1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(linear_nRM, 2))
          )
        ) %>%
        layout(
          showlegend = FALSE,
          yaxis = list(
            side = "left", title = "Max number of reps",
            showgrid = TRUE, zeroline = TRUE
          ),
          xaxis = list(
            side = "left", title = "%1RM",
            showgrid = TRUE, zeroline = FALSE
          ),
          shapes = list(hline(1), vline(100))
        )
    }

    gg
  })

  output$model_known_1RM_estimates_table <- renderDT({
    models <- known_1RM_models()

    summary_table <- tribble(
      ~model, ~k, ~`RMSE (nRM)`, ~`maxErr (nRM)`,
      "Epley's", round(coef(models$epley)[[1]], 5), round(RMSE(models$epley), 3), round(maxErr(models$epley), 3),
      "Modified Epley's", round(coef(models$epley_mod)[[1]], 5), round(RMSE(models$epley_mod), 3), round(maxErr(models$epley_mod), 3),
      "Linear", round(coef(models$linear)[[1]], 5), round(RMSE(models$linear), 3), round(maxErr(models$linear), 3)
    )
    datatable(
      summary_table,
      rownames = FALSE, selection = "none",
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  output$model_estimate_1RM_estimates_table <- renderDT({
    models <- estimate_1RM_models()

    summary_table <- tribble(
      ~model, ~`1RM`, ~k, ~`RMSE (nRM)`, ~`maxErr (nRM)`,
      "Epley's", paste0(round(get_predicted_1RM_from_k_model(models$epley), 2), "*"), round(coef(models$epley)[[2]], 5), round(RMSE(models$epley), 3), round(maxErr(models$epley), 3),
      "Modified Epley's", paste0(round(coef(models$epley_mod)[[1]], 2)), round(coef(models$epley_mod)[[2]], 5), round(RMSE(models$epley_mod), 3), round(maxErr(models$epley_mod), 3),
      "Linear", paste0(round(coef(models$linear)[[1]], 2)), round(coef(models$linear)[[2]], 5), round(RMSE(models$linear), 3), round(maxErr(models$linear), 3)
    )
    datatable(
      summary_table,
      rownames = FALSE, selection = "none",
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  output$model_known_1RM_estimates_table_reverse <- renderDT({
    models <- known_1RM_models()

    summary_table <- tribble(
      ~model, ~k, ~`RMSE (%1RM)`, ~`maxErr (%1RM)`,
      "Epley's", round(coef(models$epley_reverse)[[1]], 5), round(100 * RMSE(models$epley_reverse), 3), round(100 * maxErr(models$epley_reverse), 3),
      "Modified Epley's", round(coef(models$epley_mod_reverse)[[1]], 5), round(100 * RMSE(models$epley_mod_reverse), 3), round(100 * maxErr(models$epley_mod_reverse), 3),
      "Linear", round(coef(models$linear_reverse)[[1]], 5), round(100 * RMSE(models$linear_reverse), 3), round(100 * maxErr(models$linear_reverse), 3)
    )
    datatable(
      summary_table,
      rownames = FALSE, selection = "none",
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  output$model_estimate_1RM_estimates_table_reverse <- renderDT({
    models <- estimate_1RM_models()

    summary_table <- tribble(
      ~model, ~`1RM`, ~k, ~`RMSE (weight)`, ~`maxErr (weight)`,
      "Epley's", paste0(round(get_predicted_1RM_from_k_model(models$epley_reverse), 2), "*"), round(coef(models$epley_reverse)[[2]], 5), round(RMSE(models$epley_reverse), 3), round(maxErr(models$epley_reverse), 3),
      "Modified Epley's", paste0(round(coef(models$epley_mod_reverse)[[1]], 2)), round(coef(models$epley_mod_reverse)[[2]], 5), round(RMSE(models$epley_mod_reverse), 3), round(maxErr(models$epley_mod_reverse), 3),
      "Linear", paste0(round(coef(models$linear_reverse)[[1]], 2)), round(coef(models$linear_reverse)[[2]], 5), round(RMSE(models$linear_reverse), 3), round(maxErr(models$linear_reverse), 3)
    )
    datatable(
      summary_table,
      rownames = FALSE, selection = "none",
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  # Model plots
  output$model_known_1RM_plot_reverse <- renderPlotly({
    models <- known_1RM_models()

    observed_data <- known_1RM_table_react()

    observed_data <- na.omit(observed_data)

    observed_data$perc_1RM <- 100 * (observed_data$Weight / known_1RM_value())
    observed_data$nRM <- observed_data$Reps + observed_data$eRIR

    # Model predictions
    model_predictions <- data.frame(
      nRM = seq(0, 20, length.out = 1000)
    )

    estimated_k <- coef(models$epley_reverse)[[1]]
    estimated_kmod <- coef(models$epley_mod_reverse)[[1]]
    estimated_klin <- coef(models$linear_reverse)[[1]]

    model_predictions <- model_predictions %>%
      mutate(
        epley_perc1RM = 100 * get_max_perc_1RM_k(nRM, k = estimated_k),
        epley_mod_perc1RM = 100 * get_max_perc_1RM_kmod(nRM, kmod = estimated_kmod),
        linear_perc1RM = 100 * get_max_perc_1RM_klin(nRM, klin = estimated_klin),
        epley_weight = epley_perc1RM * known_1RM_value() / 100,
        epley_mod_weight = epley_mod_perc1RM * known_1RM_value() / 100,
        linear_weight = linear_perc1RM * known_1RM_value() / 100
      )

    gg <- plot_ly() %>%
      add_markers(
        data = observed_data, y = ~perc_1RM, x = ~nRM,
        hoverinfo = "text", opacity = 0.9, marker = list(color = "black"),
        text = ~ paste(
          "Observed data\n",
          paste("Weight =", round(Weight, 2), "\n"),
          paste("%1RM =", round(perc_1RM, 2), "\n"),
          paste("Reps =", round(nRM, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, y = ~epley_perc1RM, x = ~nRM,
        hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
        text = ~ paste(
          "Epley's model\n",
          paste("Weight =", round(epley_weight, 2), "\n"),
          paste("%1RM =", round(epley_perc1RM, 2), "\n"),
          paste("Reps =", round(nRM, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, y = ~epley_mod_perc1RM, x = ~nRM,
        hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
        text = ~ paste(
          "Modified Epley's model\n",
          paste("Weight =", round(epley_mod_weight, 2), "\n"),
          paste("%1RM =", round(epley_mod_perc1RM, 2), "\n"),
          paste("Reps =", round(nRM, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, y = ~linear_perc1RM, x = ~nRM,
        hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
        text = ~ paste(
          "Linear model\n",
          paste("Weight =", round(linear_weight, 2), "\n"),
          paste("%1RM =", round(linear_perc1RM, 2), "\n"),
          paste("Reps =", round(nRM, 2))
        )
      ) %>%
      layout(
        showlegend = FALSE,
        xaxis = list(
          side = "left", title = "Max number of reps",
          autorange = "reversed",
          showgrid = TRUE, zeroline = TRUE
        ),
        yaxis = list(
          side = "left", title = "%1RM",
          showgrid = TRUE, zeroline = FALSE
        ),
        shapes = list(vline(1), hline(100))
      )

    gg
  })


  output$model_estimate_1RM_plot_reverse <- renderPlotly({
    models <- estimate_1RM_models()

    observed_data <- estimate_1RM_table_react()

    observed_data <- na.omit(observed_data)

    observed_data$nRM <- observed_data$Reps + observed_data$eRIR

    # Model predictions
    estimated_k_0RM <- coef(models$epley_reverse)[[1]]
    estimated_kmod_1RM <- coef(models$epley_mod_reverse)[[1]]
    estimated_klin_1RM <- coef(models$linear_reverse)[[1]]

    estimated_k <- coef(models$epley_reverse)[[2]]
    estimated_kmod <- coef(models$epley_mod_reverse)[[2]]
    estimated_klin <- coef(models$linear_reverse)[[2]]

    observed_data <- observed_data %>%
      mutate(
        epley_weight = predict(models$epley_reverse, newdata = data.frame(nRM = nRM)),
        epley_mod_weight = predict(models$epley_mod_reverse, newdata = data.frame(nRM = nRM)),
        linear_weight = predict(models$linear_reverse, newdata = data.frame(nRM = nRM)),
        epley_perc1RM = 100 * epley_weight / estimated_k_0RM,
        epley_mod_perc1RM = 100 * epley_mod_weight / estimated_kmod_1RM,
        linear_perc1RM = 100 * linear_weight / estimated_klin_1RM
      )

    model_predictions <- data.frame(
      nRM = seq(0, 20, length.out = 1000)
    )

    model_predictions <- model_predictions %>%
      mutate(
        epley_weight = predict(models$epley_reverse, newdata = data.frame(nRM = nRM)),
        epley_mod_weight = predict(models$epley_mod_reverse, newdata = data.frame(nRM = nRM)),
        linear_weight = predict(models$linear_reverse, newdata = data.frame(nRM = nRM)),
        epley_perc1RM = 100 * epley_weight / estimated_k_0RM,
        epley_mod_perc1RM = 100 * epley_mod_weight / estimated_kmod_1RM,
        linear_perc1RM = 100 * linear_weight / estimated_klin_1RM
      )

    if (input$model_estimate_1RM_plot_type_reverse == "Weight") {
      gg <- plot_ly() %>%
        add_markers(
          data = observed_data, y = ~Weight, x = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "black"),
          text = ~ paste(
            "Observed data\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("Epley's %1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Modified Epley's %1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Linear %1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, y = ~epley_weight, x = ~nRM,
          hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
          text = ~ paste(
            "Epley's model\n",
            paste("Weight =", round(epley_weight, 2), "\n"),
            paste("%1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, y = ~epley_mod_weight, x = ~nRM,
          hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
          text = ~ paste(
            "Modified Epley's model\n",
            paste("Weight =", round(epley_mod_weight, 2), "\n"),
            paste("%1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, y = ~linear_weight, x = ~nRM,
          hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
          text = ~ paste(
            "Linear model\n",
            paste("Weight =", round(linear_weight, 2), "\n"),
            paste("%1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        layout(
          showlegend = FALSE,
          xaxis = list(
            side = "left", title = "Max number of reps",
            autorange = "reversed",
            showgrid = TRUE, zeroline = TRUE
          ),
          yaxis = list(
            side = "left", title = "Weight",
            showgrid = TRUE, zeroline = FALSE
          ),
          shapes = list(vline(1))
        )
    } else {
      gg <- plot_ly() %>%
        add_markers(
          data = observed_data, y = ~epley_perc1RM, x = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#FAA43A"),
          text = ~ paste(
            "Epley's prediction\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("%1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_markers(
          data = observed_data, y = ~epley_mod_perc1RM, x = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#5DA5DA"),
          text = ~ paste(
            "Modified Epley's prediction\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("%1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_markers(
          data = observed_data, y = ~linear_perc1RM, x = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#60BD68"),
          text = ~ paste(
            "Linear prediction\n",
            paste("Weight =", round(Weight, 2), "\n"),
            paste("%1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, y = ~epley_perc1RM, x = ~nRM,
          hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
          text = ~ paste(
            "Epley's model\n",
            paste("Weight =", round(epley_weight, 2), "\n"),
            paste("%1RM =", round(epley_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, y = ~epley_mod_perc1RM, x = ~nRM,
          hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
          text = ~ paste(
            "Modified Epley's model\n",
            paste("Weight =", round(epley_mod_weight, 2), "\n"),
            paste("%1RM =", round(epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, y = ~linear_perc1RM, x = ~nRM,
          hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
          text = ~ paste(
            "Linear model\n",
            paste("Weight =", round(linear_weight, 2), "\n"),
            paste("%1RM =", round(linear_perc1RM, 2), "\n"),
            paste("Reps =", round(nRM, 2))
          )
        ) %>%
        layout(
          showlegend = FALSE,
          xaxis = list(
            side = "left", title = "Max number of reps",
            autorange = "reversed",
            showgrid = TRUE, zeroline = TRUE
          ),
          yaxis = list(
            side = "left", title = "%1RM",
            showgrid = TRUE, zeroline = FALSE
          ),
          shapes = list(vline(1), hline(100))
        )
    }

    gg
  })

  # ================================================
  # Progression tables

  # Function to create example
  create_example <- function(progression_table, ...) {
    example_data <- expand_grid(
      reps = c(3, 5, 10),
      sets = c(1, 3, 5),
      step = c(-3, -2, -1, 0)
    ) %>%
      mutate(
        volume = ifelse(sets == 1, "intensive",
                        ifelse(sets == 3, "normal",
                               ifelse(sets == 5, "extensive", NA)
                        )
        ),
        volume = factor(volume, levels = c("intensive", "normal", "extensive"))
      ) %>%
      rowwise() %>%
      mutate(
        `%1RM` = round(100 * progression_table(reps = reps, step = step, volume = volume, ...)$perc_1RM, 1)
      ) %>%
      ungroup() %>%
      mutate(
        Scheme = paste0(sets, " x ", reps, " (", volume, ")"),
        step = paste0("Step ", length(unique(step)) + step)
      )

    example_data_wide <- pivot_wider(example_data, id_cols = Scheme, names_from = step, values_from = `%1RM`) %>%
      mutate(
        `Step 2-1 Diff` = round(`Step 2` - `Step 1`, 1),
        `Step 3-2 Diff` = round(`Step 3` - `Step 2`, 1),
        `Step 4-3 Diff` = round(`Step 4` - `Step 3`, 1)
      )

    example_data_wide
  }

  # Function that is reactive and returns all needed objects
  progression_table_data <- reactive({
    reps_max_tbl <- expand.grid(
      Reps = seq(1, 12),
      RIR = seq(0, 10)
    ) %>%
      mutate(
        perc_1RM = round(100 * get_max_perc_1RM(Reps, adjustment = RIR), 1)
      ) %>%
      pivot_wider(id_cols = Reps, names_from = RIR, values_from = perc_1RM)

    progression_tbl <- generate_progression_table(
      progression_table = RIR_increment,
      type = "grinding",
      # volume = "intensive",
      reps = 1:12,
      step = c(-3, -2, -1, 0)
    ) %>%
      mutate(
        perc_1RM = round(100 * perc_1RM, 1),
        adjustment = round(adjustment, 1),
        step = length(unique(step)) + step) %>%
      rename(Step = step, Reps = reps)

    example_schemes <- create_example(RIR_increment)

    list(
      reps_max_tbl = reps_max_tbl,
      progression_tbl = progression_tbl,
      example_schemes = example_schemes
    )
  })


  # Reps-max plot
  output$reps_max_table <- renderDT({
    reps_max_tbl <- progression_table_data()$reps_max_tbl

    DT::datatable(
      reps_max_tbl,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  # Estimated 1RMs
  output$progression_table_intensive_perc1RM <- renderDT({
    progression_tbl <- progression_table_data()$progression_tbl %>%
      filter(volume == "intensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = perc_1RM)

    DT::datatable(
      progression_tbl,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  output$progression_table_normal_perc1RM <- renderDT({
    progression_tbl <- progression_table_data()$progression_tbl %>%
      filter(volume == "normal") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = perc_1RM)

    DT::datatable(
      progression_tbl,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  output$progression_table_extensive_perc1RM <- renderDT({
    progression_tbl <- progression_table_data()$progression_tbl %>%
      filter(volume == "extensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = perc_1RM)

    DT::datatable(
      progression_tbl,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })


  # Used Adjustments
  output$progression_table_intensive_adjustment <- renderDT({
    progression_tbl <- progression_table_data()$progression_tbl %>%
      filter(volume == "intensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = adjustment)

    DT::datatable(
      progression_tbl,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  output$progression_table_normal_adjustment <- renderDT({
    progression_tbl <- progression_table_data()$progression_tbl %>%
      filter(volume == "normal") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = adjustment)

    DT::datatable(
      progression_tbl,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  output$progression_table_extensive_adjustment <- renderDT({
    progression_tbl <- progression_table_data()$progression_tbl %>%
      filter(volume == "extensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = adjustment)

    DT::datatable(
      progression_tbl,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  # Example schemes
  output$progression_table_example_scheme <- renderDT({
    example_schemes <- progression_table_data()$example_schemes

    DT::datatable(
      example_schemes,
      rownames = FALSE,
      selection = "none",
      editable = FALSE,
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
