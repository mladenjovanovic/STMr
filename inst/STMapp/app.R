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
hline <- function(y = 0, color = "black") {
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

RMSE <- function(model) {
  sqrt(mean(resid(model)^2))
}
#################################################
# UI
#################################################
ui <- dashboardPage(
  dashboardHeader(title = "STMapp"),

  # Sidebar items
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Entry", tabName = "data_entry_menu_item", icon = icon("dumbbell"))
    ) # sidebarMenu
  ), # DashboardSidebar

  # Body
  dashboardBody(
    fluidPage(
      tabItems(
        # ================================
        tabItem(
          tabName = "data_entry_menu_item",
          box(
            title = "Settings",
            id = "data_entry_settings",
            width = 12
          ), # Data Entry Settings
          column(
            6,
            box(
              title = "Known 1RM",
              id = "data_entry_known_1RM",
              width = 12,
              numericInput("data_entry_known_1RM_value", label = "1RM", value = 150, min = 0, max = 1000, step = 1),
              br(),
              DTOutput("data_entry_known_1RM_table"),
              br(),
              actionButton("data_entry_known_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start"))
            ), # Box Known 1RM
            box(
              title = "Model estimates",
              id = "model_known_1RM_estimates",
              width = 12,
              dataTableOutput("model_known_1RM_estimates_table")
            ), # Known 1RM estimates
            box(
              title = "Model predictions",
              id = "model_known_1RM_predictions",
              width = 12,
              plotlyOutput("model_known_1RM_plot")
            ) # Known 1RM plots
          ), # Column
          column(
            6,
            box(
              title = "Estimate 1RM",
              id = "data_entry_estimate_1RM",
              width = 12,
              DTOutput("data_entry_estimate_1RM_table"),
              br(),
              actionButton("data_entry_estimate_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start"))
            ), # Box Estimate 1RM
            box(
              title = "Model estimates",
              id = "model_estimate_1RM_estimates",
              width = 12,
              dataTableOutput("model_estimate_1RM_estimates_table")
            ), # Estimate 1RM estimates
            box(
              title = "Model preditions",
              id = "model_estimate_1RM_predictions",
              width = 12,
              selectInput(
                "model_estimate_1RM_plot_type",
                label = "Plot",
                choices = c("Weight", "Estimated %1RMs")
              ),
              plotlyOutput("model_estimate_1RM_plot")
            ) # Estimated 1RM plot
          ) # Column
        ) # Data Entry Tab
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

      # Modified Epley's model
      linear <- estimate_klin(
        perc_1RM = model_data$perc_1RM,
        reps = model_data$nRM
      )

      # Return
      list(
        epley = epley,
        epley_mod = epley_mod,
        linear = linear
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
        reps = model_data$nRM
      )

      # Modified Epley's model
      epley_mod <- estimate_kmod_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM
      )

      # Modified Epley's model
      linear <- estimate_klin_1RM(
        weight = model_data$Weight,
        reps = model_data$nRM
      )

      # Return
      list(
        epley = epley,
        epley_mod = epley_mod,
        linear = linear
      )
    },
    ignoreNULL = FALSE
  )

  # Model plots
  output$model_known_1RM_plot <- renderPlotly({
    models <- known_1RM_models()

    model_data <- known_1RM_table_react()

    model_data <- na.omit(model_data)

    model_data$perc_1RM <- 100 * (model_data$Weight / known_1RM_value())
    model_data$nRM <- model_data$Reps + model_data$eRIR

    # Model predictions
    model_predictions <- data.frame(
      perc_1RM = seq(0.5, 1, length.out = 1000)
    )

    model_predictions$epley <- predict(models$epley, newdata = data.frame(perc_1RM = model_predictions$perc_1RM))
    model_predictions$epley_mod <- predict(models$epley_mod, newdata = data.frame(perc_1RM = model_predictions$perc_1RM))
    model_predictions$linear <- predict(models$linear, newdata = data.frame(perc_1RM = model_predictions$perc_1RM))

    model_predictions$Weight <- model_predictions$perc_1RM * known_1RM_value()
    model_predictions$perc_1RM <- model_predictions$perc_1RM * 100

    gg <- plot_ly() %>%
      add_markers(
        data = model_data, x = ~perc_1RM, y = ~nRM,
        hoverinfo = "text", opacity = 0.9, marker = list(color = "black"),
        text = ~ paste(
          "Observed data\n",
          paste("Weight =", round(model_data$Weight, 2), "\n"),
          paste("%1RM =", round(model_data$perc_1RM, 2), "\n"),
          paste("Reps =", round(model_data$nRM, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, x = ~perc_1RM, y = ~epley,
        hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
        text = ~ paste(
          "Epley's model\n",
          paste("Weight =", round(model_predictions$Weight, 2), "\n"),
          paste("%1RM =", round(model_predictions$perc_1RM, 2), "\n"),
          paste("Reps =", round(model_predictions$epley, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, x = ~perc_1RM, y = ~epley_mod,
        hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
        text = ~ paste(
          "Modified Epley's model\n",
          paste("Weight =", round(model_predictions$Weight, 2), "\n"),
          paste("%1RM =", round(model_predictions$perc_1RM, 2), "\n"),
          paste("Reps =", round(model_predictions$epley_mod, 2))
        )
      ) %>%
      add_lines(
        data = model_predictions, x = ~perc_1RM, y = ~linear,
        hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
        text = ~ paste(
          "Linear model\n",
          paste("Weight =", round(model_predictions$Weight, 2), "\n"),
          paste("%1RM =", round(model_predictions$perc_1RM, 2), "\n"),
          paste("Reps =", round(model_predictions$linear, 2))
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
        shapes = list(hline(1))
      )

    gg
  })

  output$model_estimate_1RM_plot <- renderPlotly({
    models <- estimate_1RM_models()

    model_data <- estimate_1RM_table_react()

    model_data <- na.omit(model_data)
    model_data$nRM <- model_data$Reps + model_data$eRIR

    # Model predictions
    model_predictions <- data.frame(
      weight = seq(0.8 * min(model_data$Weight), max(coef(models$epley)[[1]], coef(models$epley_mod)[[1]]), length.out = 1000)
    )

    model_predictions$epley <- predict(models$epley, newdata = data.frame(weight = model_predictions$weight))
    model_predictions$epley_mod <- predict(models$epley_mod, newdata = data.frame(weight = model_predictions$weight))
    model_predictions$linear <- predict(models$linear, newdata = data.frame(weight = model_predictions$weight))


    model_predictions$epley_perc1RM <- 100 * model_predictions$weight / coef(models$epley)[[1]]
    model_predictions$epley_mod_perc1RM <- 100 * model_predictions$weight / coef(models$epley_mod)[[1]]
    model_predictions$linear_perc1RM <- 100 * model_predictions$weight / coef(models$linear)[[1]]

    model_data$epley_perc1RM <- 100 * model_data$Weight / coef(models$epley)[[1]]
    model_data$epley_mod_perc1RM <- 100 * model_data$Weight / coef(models$epley_mod)[[1]]
    model_data$linear_perc1RM <- 100 * model_data$Weight / coef(models$linear)[[1]]

    if (input$model_estimate_1RM_plot_type == "Weight") {
      gg <- plot_ly() %>%
        add_markers(
          data = model_data, x = ~Weight, y = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "black"),
          text = ~ paste(
            "Observed data\n",
            paste("Weight =", round(model_data$Weight, 2), "\n"),
            paste("Epley's %1RM =", round(model_data$epley_perc1RM, 2), "\n"),
            paste("Modified Epley's %1RM =", round(model_data$epley_mod_perc1RM, 2), "\n"),
            paste("Linear %1RM =", round(model_data$linear_perc1RM, 2), "\n"),
            paste("Reps =", round(model_data$nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~weight, y = ~epley,
          hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
          text = ~ paste(
            "Epley's model\n",
            paste("Weight =", round(model_predictions$weight, 2), "\n"),
            paste("%1RM =", round(model_predictions$epley_perc1RM, 2), "\n"),
            paste("Reps =", round(model_predictions$epley, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~weight, y = ~epley_mod,
          hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
          text = ~ paste(
            "Modified Epley's model\n",
            paste("Weight =", round(model_predictions$weight, 2), "\n"),
            paste("%1RM =", round(model_predictions$epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(model_predictions$epley_mod, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~weight, y = ~linear,
          hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
          text = ~ paste(
            "Linear model\n",
            paste("Weight =", round(model_predictions$weight, 2), "\n"),
            paste("%1RM =", round(model_predictions$linear_perc1RM, 2), "\n"),
            paste("Reps =", round(model_predictions$linear, 2))
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
          data = model_data, x = ~epley_perc1RM, y = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#FAA43A"),
          text = ~ paste(
            "Epley's prediction\n",
            paste("Weight =", round(model_data$Weight, 2), "\n"),
            paste("%1RM =", round(model_data$epley_perc1RM, 2), "\n"),
            paste("Reps =", round(model_data$nRM, 2))
          )
        ) %>%
        add_markers(
          data = model_data, x = ~epley_mod_perc1RM, y = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#5DA5DA"),
          text = ~ paste(
            "Modified Epley's prediction\n",
            paste("Weight =", round(model_data$Weight, 2), "\n"),
            paste("%1RM =", round(model_data$epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(model_data$nRM, 2))
          )
        ) %>%
        add_markers(
          data = model_data, x = ~linear_perc1RM, y = ~nRM,
          hoverinfo = "text", opacity = 0.9, marker = list(color = "#60BD68"),
          text = ~ paste(
            "Linear prediction\n",
            paste("Weight =", round(model_data$Weight, 2), "\n"),
            paste("%1RM =", round(model_data$linear_perc1RM, 2), "\n"),
            paste("Reps =", round(model_data$nRM, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~epley_perc1RM, y = ~epley,
          hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
          text = ~ paste(
            "Epley's model\n",
            paste("Weight =", round(model_predictions$weight, 2), "\n"),
            paste("%1RM =", round(model_predictions$epley_perc1RM, 2), "\n"),
            paste("Reps =", round(model_predictions$epley, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~epley_mod_perc1RM, y = ~epley_mod,
          hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
          text = ~ paste(
            "Modified Epley's model\n",
            paste("Weight =", round(model_predictions$weight, 2), "\n"),
            paste("%1RM =", round(model_predictions$epley_mod_perc1RM, 2), "\n"),
            paste("Reps =", round(model_predictions$epley_mod, 2))
          )
        ) %>%
        add_lines(
          data = model_predictions, x = ~linear_perc1RM, y = ~linear,
          hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
          text = ~ paste(
            "Linear model\n",
            paste("Weight =", round(model_predictions$weight, 2), "\n"),
            paste("%1RM =", round(model_predictions$linear_perc1RM, 2), "\n"),
            paste("Reps =", round(model_predictions$linear, 2))
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
          shapes = list(hline(1))
        )
    }

    gg
  })

  output$model_known_1RM_estimates_table <- renderDT({
    models <- known_1RM_models()

    summary_table <- tribble(
      ~model, ~k, ~RMSE,
      "Epley's", round(coef(models$epley)[[1]], 5), round(RMSE(models$epley), 3),
      "Modified Epley's", round(coef(models$epley_mod)[[1]], 5), round(RMSE(models$epley_mod), 3),
      "Linear", round(coef(models$linear)[[1]], 5), round(RMSE(models$linear), 3)
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
      ~model, ~`1RM`, ~k, ~RMSE,
      "Epley's", round(coef(models$epley)[[1]], 2), round(coef(models$epley)[[2]], 5), round(RMSE(models$epley), 3),
      "Modified Epley's", round(coef(models$epley_mod)[[1]], 2), round(coef(models$epley_mod)[[2]], 5), round(RMSE(models$epley_mod), 3),
      "Linear", round(coef(models$linear)[[1]], 2), round(coef(models$linear)[[2]], 5), round(RMSE(models$linear), 3)
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
}

# Run the application
shinyApp(ui = ui, server = server)
