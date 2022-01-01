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
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Entry", tabName = "menu-item-data-entry", icon = icon("dumbbell")),
      menuItem("Progression Tables", tabName = "menu-item-progression-tables", icon = icon("table"))
    ) # Sidebar menu
  ), # Dashboard sidebar
  # Body
  dashboardBody(
    fluidPage(
      tabItems(
        tabItem(
          tabName = "menu-item-data-entry",
          tabBox(
            id = "tabbox-data-entry",
            title = "Data Entry", width = 12,
            # Known 1RM data entry
            tabPanel(
              title = "Known 1RM",
              fluidPage(
                column(
                  5,
                  h4("Use this approach when you have known 1RM value"),
                  numericInput("data_entry_known_1RM_value", label = "1RM", value = 150, min = 0, max = 1000, step = 1),
                  h5("Enter known 1RM. This will be used to estimate %1RM from weights used"),
                  br(),
                  DTOutput("data_entry_known_1RM_table"),
                  h5("Enter weights and reps done. If needed, you can also enter estimated reps-in-reserve (eRIR). If not used, leave 0"),
                  br(),
                  actionButton("data_entry_known_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start"))
                ),
                column(1),
                column(
                  6,
                  h3("Model using %1RM as predictor and nRM as target variable"),
                  dataTableOutput("model_known_1RM_estimates_table"),
                  br(),
                  plotlyOutput("model_known_1RM_plot"),
                  br(),
                  h3("Model using nRM as predictor and %1RM as target variable"),
                  dataTableOutput("model_known_1RM_estimates_table_reverse"),
                  br(),
                  plotlyOutput("model_known_1RM_plot_reverse")
                )
              ) # Fluid Page
            ), # Known 1RM data entry
            tabPanel(
              title = "Estimate 1RM",
              fluidPage(
                column(
                  5,
                  h4("Use this approach when you do not know athlete's 1RM, but want to estimate it"),
                  DTOutput("data_entry_estimate_1RM_table"),
                  h5("Enter weights and reps done. If needed, you can also enter estimated reps-in-reserve (eRIR). If not used, leave 0"),
                  br(),
                  actionButton("data_entry_estimate_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start")),
                  br(),
                  br(),
                  selectInput(
                    "model_estimate_1RM_plot_type",
                    label = "Plot",
                    choices = c("Weight", "Estimated %1RMs")
                  ),
                  h5("Select if you want weight plotted or estimated %1RM")
                ),
                column(1),
                column(
                  6,
                  h3("Model using weight as predictor and nRM as target variable"),
                  dataTableOutput("model_estimate_1RM_estimates_table"),
                  br(),
                  plotlyOutput("model_estimate_1RM_plot"),
                  br(),
                  h3("Model using nRM as predictor and weight as target variable"),
                  dataTableOutput("model_estimate_1RM_estimates_table_reverse"),
                  br(),
                  plotlyOutput("model_estimate_1RM_plot_reverse")
                )
              ) # Fluid Page
            ) # Estimate 1RM data entry
          ) #
        ), # Data Entry
        tabItem(
          tabName = "menu-item-progression-tables"
        ) # Progression Tables
      ) # Tab items
    ) # Fluid Page
  ) # Dashboard body
) # Dashboard page

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

    if (input$model_estimate_1RM_plot_type == "Weight") {
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

  # Function to generate

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
    # Get the parameter value
    if (input$settings_data == "Generic values") {
      parameter_value <- switch(input$settings_model,
        "Epley's" = 0.0333,
        "Modified Epley's" = 0.0353,
        "Linear" = 33
      )
    } else if ((input$settings_data == "Known 1RM")) {
      models <- known_1RM_models()

      if (input$settings_model_type == "nRM as Target variable") {
        parameter_value <- switch(input$settings_model,
          "Epley's" = coef(models$epley)[[1]],
          "Modified Epley's" = coef(models$epley_mod)[[1]],
          "Linear" = coef(models$linear)[[1]]
        )
      } else if (input$settings_model_type == "nRM as Predictor variable") {
        parameter_value <- switch(input$settings_model,
          "Epley's" = coef(models$epley_reverse)[[1]],
          "Modified Epley's" = coef(models$epley_mod_reverse)[[1]],
          "Linear" = coef(models$linear_reverse)[[1]]
        )
      }
    } else if ((input$settings_data == "Estimated 1RM")) {
      models <- estimate_1RM_models()

      if (input$settings_model_type == "nRM as Target variable") {
        parameter_value <- switch(input$settings_model,
          "Epley's" = coef(models$epley)[[2]],
          "Modified Epley's" = coef(models$epley_mod)[[2]],
          "Linear" = coef(models$linear)[[2]]
        )
      } else if (input$settings_model_type == "nRM as Predictor variable") {
        parameter_value <- switch(input$settings_model,
          "Epley's" = coef(models$epley_reverse)[[2]],
          "Modified Epley's" = coef(models$epley_mod_reverse)[[2]],
          "Linear" = coef(models$linear_reverse)[[2]]
        )
      }
    }

    # Function factory for the reps-max equation
    get_max_perc_1RM_RIR_func <- switch(input$settings_model,
      "Epley's" = function(...) get_max_perc_1RM_k(..., k = parameter_value),
      "Modified Epley's" = function(...) get_max_perc_1RM_kmod(..., kmod = parameter_value),
      "Linear" =  function(...) get_max_perc_1RM_klin(..., klin = parameter_value)
    )

    get_max_perc_1RM_relInt_func <- switch(input$settings_model,
      "Epley's" = function(...) get_max_perc_1RM_k_relInt(..., k = parameter_value),
      "Modified Epley's" = function(...) get_max_perc_1RM_kmod_relInt(..., kmod = parameter_value),
      "Linear" =  function(...) get_max_perc_1RM_klin_relInt(..., klin = parameter_value)
    )

    get_max_perc_1RM_percMR_func <- switch(input$settings_model,
      "Epley's" = function(...) get_max_perc_1RM_k_percMR(..., k = parameter_value),
      "Modified Epley's" = function(...) get_max_perc_1RM_kmod_percMR(..., kmod = parameter_value),
      "Linear" =  function(...) get_max_perc_1RM_klin_percMR(..., klin = parameter_value)
    )

    get_max_perc_1RM_DI_func <- switch(input$settings_model,
      "Epley's" = function(..., adjustment) get_max_perc_1RM_k(..., k = parameter_value) + adjustment,
      "Modified Epley's" = function(..., adjustment) get_max_perc_1RM_kmod(..., kmod = parameter_value) + adjustment,
      "Linear" =  function(..., adjustment) get_max_perc_1RM_klin(..., klin = parameter_value) + adjustment
    )

    # Function factory for the progression table
    progression_table_func <- switch(input$settings_progression_table,
      "Deducted Intensity 2.5%" = function(...) perc_drop_fixed_25(..., func_max_perc_1RM = get_max_perc_1RM_RIR_func),
      "Deducted Intensity 5%" = function(...) perc_drop_fixed_5(..., func_max_perc_1RM = get_max_perc_1RM_RIR_func),
      "Relative Intensity" = function(...) relInt(..., func_max_perc_1RM = get_max_perc_1RM_relInt_func),
      "Perc Drop" = function(...) perc_drop(..., func_max_perc_1RM = get_max_perc_1RM_RIR_func),
      "RIR 1" = function(...) RIR_increment_fixed_1(..., func_max_perc_1RM = get_max_perc_1RM_RIR_func),
      "RIR 2" = function(...) RIR_increment_fixed_2(..., func_max_perc_1RM = get_max_perc_1RM_RIR_func),
      "RIR Inc" = function(...) RIR_increment(..., func_max_perc_1RM = get_max_perc_1RM_RIR_func),
      "%MR Step Const" = function(...) percMR_step_const(..., func_max_perc_1RM = get_max_perc_1RM_percMR_func),
      "%MR Step Var" = function(...) percMR_step_var(..., func_max_perc_1RM = get_max_perc_1RM_percMR_func)
    )

    adjustment_seq <- switch(input$settings_progression_table,
      "Deducted Intensity 2.5%" = seq(0, -30, by = -2.5) / 100,
      "Deducted Intensity 5%" = seq(0, -60, by = -5) / 100,
      "Relative Intensity" = seq(100, 60, by = -2.5) / 100,
      "Perc Drop" = seq(0, -30, by = -2.5) / 100,
      "RIR 1" = seq(0, 15, by = 1),
      "RIR 2" = seq(0, 15, by = 1),
      "RIR Inc" = seq(0, 15, by = 1),
      "%MR Step Const" = seq(100, 30, by = -5) / 100,
      "%MR Step Var" = seq(100, 30, by = -5) / 100
    )

    adjustment_values <- switch(input$settings_progression_table,
      "Deducted Intensity 2.5%" = paste0(seq(0, -30, by = -2.5), "%"),
      "Deducted Intensity 5%" = paste0(seq(0, -60, by = -5), "%"),
      "Relative Intensity" = paste0(seq(100, 60, by = -2.5), "%"),
      "Perc Drop" = paste0(seq(0, -30, by = -2.5), "%"),
      "RIR 1" = paste0(seq(0, 15, by = 1), "RIR"),
      "RIR 2" = paste0(seq(0, 15, by = 1), "RIR"),
      "RIR Inc" = paste0(seq(0, 15, by = 1), "RIR"),
      "%MR Step Const" = paste0(seq(100, 30, by = -5), "%MR"),
      "%MR Step Var" = paste0(seq(100, 30, by = -5), "%MR")
    )

    get_max_perc_1RM_func <- switch(input$settings_progression_table,
      "Deducted Intensity 2.5%" = get_max_perc_1RM_DI_func,
      "Deducted Intensity 5%" = get_max_perc_1RM_DI_func,
      "Relative Intensity" = get_max_perc_1RM_relInt_func,
      "Perc Drop" = get_max_perc_1RM_RIR_func,
      "RIR 1" = get_max_perc_1RM_RIR_func,
      "RIR 2" = get_max_perc_1RM_RIR_func,
      "RIR Inc" = get_max_perc_1RM_RIR_func,
      "%MR Step Const" = get_max_perc_1RM_percMR_func,
      "%MR Step Var" = get_max_perc_1RM_percMR_func
    )

    # Table types
    table_type <- switch(input$settings_progression_table_type,
      "Grinding" = "grinding",
      "Ballistic" = "ballistic"
    )

    reps_max_tbl <- expand_grid(
      Reps = seq(1, 12),
      data.frame(adjustment = adjustment_seq, adjustment_val = adjustment_values)
    ) %>%
      mutate(
        perc_1RM = round(100 * get_max_perc_1RM_func(max_reps = Reps, adjustment = adjustment, type = table_type), 1)
      ) %>%
      pivot_wider(id_cols = Reps, names_from = adjustment_val, values_from = perc_1RM)

    example_schemes <- create_example(progression_table_func, type = table_type)

    progression_tbl <- generate_progression_table(
      progression_table = progression_table_func,
      type = table_type,
      reps = 1:12,
      step = c(-3, -2, -1, 0)
    ) %>%
      mutate(
        perc_1RM = round(100 * perc_1RM, 1),
        adjustment = switch(input$settings_progression_table,
          "Deducted Intensity 2.5%" = round(adjustment * 100, 1),
          "Deducted Intensity 5%" = round(adjustment * 100, 1),
          "Relative Intensity" = round(adjustment * 100, 1),
          "Perc Drop" = round(adjustment * 100, 1),
          "RIR 1" = round(adjustment, 1),
          "RIR 2" = round(adjustment, 1),
          "RIR Inc" = round(adjustment, 1),
          "%MR Step Const" = round(adjustment * 100, 1),
          "%MR Step Var" = round(adjustment * 100, 1)
        ),
        step = length(unique(step)) + step
      ) %>%
      rename(Step = step, Reps = reps)

    list(
      reps_max_tbl = reps_max_tbl,
      reps_max_tbl = reps_max_tbl,
      progression_tbl = progression_tbl,
      example_schemes = example_schemes,
      get_max_perc_1RM_func = get_max_perc_1RM_func,
      progression_table_func = progression_table_func
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


  # ===================================================
  #
  # Schemes
  #
  # ===================================================

  output$schemes_generate_scheme <- renderPlot({
    scheme <- scheme_wave(
      reps = c(12, 10, 8, 12, 10, 8),
      # Adjusting sets to use lower %1RM (RIR Inc method used, so RIR adjusted)
      adjustment = c(4, 2, 0, 6, 4, 2),
      vertical_planning = vertical_linear,
      vertical_planning_control = list(reps_change = c(0, -2, -4, -6)),
      progression_table = RIR_increment,
      progression_table_control = list(volume = "extensive")
    )

    plot_scheme(scheme)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
