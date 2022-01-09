library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(STM)
library(plotly)
library(QWUtils)


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

# For plotly
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


#################################################
# UI
#################################################

ui <- dashboardPage(
  dashboardHeader(title = "strengthPRO"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Single Athlete", tabName = "menu-item-single-athlete", icon = icon("user")),
      menuItem("Multiple Athletes", tabName = "menu-item-multiple-athletes", icon = icon("users"))
    ) # Sidebar menu
  ), # Dashboard sidebar
  # Body
  dashboardBody(
    fluidPage(
      tabItems(
        tabItem(
          tabName = "menu-item-single-athlete",
          box(
            title = "Data entry",
            width = 12,
            collapsible = TRUE,
            fluidRow(
              column(
                5,
                numericInput("single_athlete_1RM", label = "1RM", value = 150, min = 0, max = 1000, step = 1),
                h5("If athlete's 1RM is known, it will be used to calculate %1RMs"),
                h5("If athlete's 1RM is unknown, leave the input blank and the model will estimate it"),
                br(),
                DTOutput("single_athlete_weights_reps_table"),
                h5("Enter weights and reps done. If needed, you can also enter estimated reps-in-reserve (eRIR). If not used, leave 0 or empty"),
                br(),
                actionButton("single_athlete_model_button", "Model", class = "btn-large btn-success", icon = icon("hourglass-start")),
                br(), br(),
                HTML("<b>Note:</b> In both models utilized (i.e., known and unknown 1RM), repetitions (actually nRMs) are used as a target variable.
                      In the model with the known 1RM, %1RM is used as a predictor. In the model with the unknown 1RM, weight is used as a predictor.")
              ),
              column(
                1
              ),
              column(
                6,
                dataTableOutput("single_athlete_model_performance"),
                br(),
                HTML("<b>Note:</b> Model performances (i.e., RMSE and maxErr) are estmated using the actual/observed nRM and model predicted nRM.
                     When 1RM is unknown, table will contain estimated 1RMs. Epley's model predicted 1RM uses predicted weight at 1 rep (1RM).
                     Predicted 1RM using Generic Epley's model represents <i>average</i> of predicted 1RMs using observed weights and reps done."),
                br(), br(),
                plotlyOutput("single_athlete_model_plot"),
                br(),
                HTML("<b>Note:</b> Please note that, although the models are fitted using nRM as target variable, here we are using nRM as predictor
                     variable (since we are going to use it as such in the progression tables). When 1RM is known, graph will depict observed 1RMs as
                     black dots and model predictions as lines. When 1RM is unknown, the graph will depict model estimated %1RMs, since we do not
                     know observed %1RMs (because observed 1RM is unknown). In both cases, estimated parameters will be used to calculate %1RM at
                     a given nRM."),
              )
            )
          ) # Single Athlete Data Entry
        ), # Single Athlete
        tabItem(
          tabName = "menu-item-multiple-athletes"
        ) # Multiple Athletes
      ) # Tab Items
    ) # Fluid Page
  ) # Dashboard body
)



#################################################
# Server
#################################################
server <- function(input, output) {

  ###########################################
  # Single athlete
  ##########################################

  # Single athlete observed performance table
  single_athlete_observed_performance <- reactiveValues(data = {
    tibble(Weight = numeric(0), Reps = numeric(0), eRIR = numeric(0)) %>%
      add_row(
        Weight = c(135, 120, 105, NA, NA),
        Reps = c(3, 8, 12, NA, NA),
        eRIR = c(NA, NA, NA, NA, NA)
      )
  })

  # Function to updated edited values in single athlete performance table
  observeEvent(input$single_athlete_weights_reps_table_cell_edit, {
    # get values
    info <- input$single_athlete_weights_reps_table_cell_edit
    i <- as.numeric(info$row)
    j <- as.numeric(info$col) + 1
    k <- as.numeric(info$value)

    # write values to reactive
    single_athlete_observed_performance$data[i, j] <- k
  })

  # Single athlete observed performance table
  output$single_athlete_weights_reps_table <- renderDT({
    DT::datatable(
      single_athlete_observed_performance$data,
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

  # Reactive value to return models and observed data
  single_athlete_model <- eventReactive(input$single_athlete_model_button,
    {

      # Functions to estimate model performance
      RMSE <- function(observed, predicted) {
        resids <- predicted - observed
        sqrt(mean(resids^2))
      }

      # Max absolute error
      maxErr <- function(observed, predicted) {
        resids <- predicted - observed

        if (all(is.na(resids))) {
          NA
        } else {
          resids[[which.max(abs(resids))]]
        }
      }

      # Get the observed performance

      observed_1RM_value <- input$single_athlete_1RM

      observed_data <- single_athlete_observed_performance$data %>%
        # If eRIR is NA, assume it is 0
        mutate(eRIR = if_else(is.na(eRIR), 0, eRIR)) %>%
        # Remove missing values
        na.omit() %>%
        # nRM is equal to reps done plus eRIR
        mutate(
          nRM = Reps + eRIR,
          oneRM = observed_1RM_value,
          perc_1RM = Weight / oneRM
        )

      # Model
      if (!is.na(observed_1RM_value)) {
        # The 1RM is known
        # Epley's model
        epley <- estimate_k(
          perc_1RM = observed_data$perc_1RM,
          reps = observed_data$nRM,
          weighted = TRUE
        )

        # Modified Epley's model
        epley_mod <- estimate_kmod(
          perc_1RM = observed_data$perc_1RM,
          reps = observed_data$nRM,
          weighted = TRUE
        )

        # Linear model
        linear <- estimate_klin(
          perc_1RM = observed_data$perc_1RM,
          reps = observed_data$nRM,
          weighted = TRUE
        )
      } else {
        # 1RM must be estimated
        # Epley's model
        epley <- estimate_k_1RM(
          weight = observed_data$Weight,
          reps = observed_data$nRM,
          weighted = TRUE
        )

        # Modified Epley's model
        epley_mod <- estimate_kmod_1RM(
          weight = observed_data$Weight,
          reps = observed_data$nRM,
          weighted = TRUE
        )

        # Linear model
        linear <- estimate_klin_1RM(
          weight = observed_data$Weight,
          reps = observed_data$nRM,
          weighted = TRUE
        )
      }

      # Model parameters
      epley_k <- coef(epley)[[1]]
      epley_kmod <- coef(epley_mod)[[1]]
      linear_klin <- coef(linear)[[1]]
      generic_k <- 0.0333

      if (is.na(observed_1RM_value)) {
        epley_0RM <- coef(epley)[[2]]
        epley_1RM <- get_predicted_1RM_from_k_model(epley)
        epley_mod_1RM <- coef(epley_mod)[[2]]
        linear_1RM <- coef(linear)[[2]]

        # Generic 1RM is estimated using average of all sets
        generic_1RM <- mean(get_predicted_1RM(observed_data$Weight, observed_data$nRM))
      } else {
        epley_0RM <- observed_1RM_value
        epley_1RM <- observed_1RM_value
        epley_mod_1RM <- observed_1RM_value
        linear_1RM <- observed_1RM_value
        generic_1RM <- observed_1RM_value
      }

      # Update the observed data with model performance
      observed_data <- observed_data %>%
        mutate(
          predicted_epley_nRM = predict(epley),
          predicted_epley_mod_nRM = predict(epley_mod),
          predicted_linear_nRM = predict(linear),
          predicted_generic_nRM = get_max_reps(Weight / generic_1RM),
          predicted_epley_perc1RM = 100 * get_max_perc_1RM_k(nRM, k = epley_k),
          predicted_epley_mod_perc1RM = 100 * get_max_perc_1RM_kmod(nRM, kmod = epley_kmod),
          predicted_linear_perc1RM = 100 * get_max_perc_1RM_klin(nRM, klin = linear_klin),
          predicted_generic_perc1RM = 100 * get_max_perc_1RM(nRM)
        )

      # Put all of that in the table
      model_params <- tribble(
        ~model, ~k, ~`1RM`,
        "Epley", epley_k, epley_1RM,
        "Modified Epley", epley_kmod, epley_mod_1RM,
        "Linear", linear_klin, linear_1RM,
        "Generic Epley", generic_k, generic_1RM
      )

      # Model performance
      model_performance <- observed_data %>%
        rename(
          "Epley" = "predicted_epley_nRM",
          "Modified Epley" = "predicted_epley_mod_nRM",
          "Linear" = "predicted_linear_nRM",
          "Generic Epley" = "predicted_generic_nRM"
        ) %>%
        pivot_longer(
          cols = c("Epley", "Modified Epley", "Linear", "Generic Epley"),
          names_to = "model"
        ) %>%
        group_by(model) %>%
        summarise(
          `RMSE (nRM)` = RMSE(nRM, value),
          `maxErr (nRM)` = maxErr(nRM, value)
        )


      # Merge two tables
      # This is "print friendly" table that rounds
      model_characteristics <- left_join(model_params, model_performance, by = "model")

      model_characteristics <- model_characteristics %>%
        mutate(
          k = signif(k, 4),
          `1RM` = round(`1RM`, 2),
          `RMSE (nRM)` = round(`RMSE (nRM)`, 2),
          `maxErr (nRM)` = round(`maxErr (nRM)`, 2)
        )

      if (!is.na(observed_1RM_value)) {
        # 1RM is known
        model_characteristics <- model_characteristics %>%
          select(-`1RM`)
      }

      # Graph data
      model_predictions_df <- data.frame(
        nRM = seq(0, 20, length.out = 1000)
      ) %>%
        mutate(
          predicted_epley_perc1RM = 100 * get_max_perc_1RM_k(nRM, k = epley_k),
          predicted_epley_mod_perc1RM = 100 * get_max_perc_1RM_kmod(nRM, kmod = epley_kmod),
          predicted_linear_perc1RM = 100 * get_max_perc_1RM_klin(nRM, klin = linear_klin),
          predicted_generic_perc1RM = 100 * get_max_perc_1RM(nRM)
        )

      observed_data <- observed_data %>%
        mutate(perc_1RM = perc_1RM * 100)

      # Plotly object
      if (!is.na(observed_1RM_value)) {
        # Known 1RMs, thus known %1RMs
        plotly_plot <- plot_ly() %>%
          add_markers(
            data = observed_data, y = ~perc_1RM, x = ~nRM,
            hoverinfo = "text", opacity = 0.9, marker = list(color = "black", size = 10),
            text = ~ paste(
              "Observed data\n",
              paste("%1RM =", round(perc_1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_epley_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
            text = ~ paste(
              "Epley's model\n",
              paste("%1RM =", round(predicted_epley_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_epley_mod_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
            text = ~ paste(
              "Modified Epley's model\n",
              paste("%1RM =", round(predicted_epley_mod_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_linear_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
            text = ~ paste(
              "Linear model\n",
              paste("%1RM =", round(predicted_linear_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_generic_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "grey", dash = "dash"), opacity = 0.5,
            text = ~ paste(
              "Generic model\n",
              paste("%1RM =", round(predicted_generic_perc1RM, 2), "\n"),
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
      } else {
        # Unknown 1RMs, thus unknown %1RMs
        plotly_plot <- plot_ly() %>%
          add_markers(
            data = observed_data, y = ~predicted_epley_perc1RM, x = ~nRM,
            hoverinfo = "text", opacity = 0.9, marker = list(color = "#FAA43A", size = 10),
            text = ~ paste(
              "Epley's prediction\n",
              paste("%1RM =", round(predicted_epley_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_markers(
            data = observed_data, y = ~predicted_epley_mod_perc1RM, x = ~nRM,
            hoverinfo = "text", opacity = 0.9, marker = list(color = "#5DA5DA", size = 10),
            text = ~ paste(
              "Modified Epley's prediction\n",
              paste("%1RM =", round(predicted_epley_mod_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_markers(
            data = observed_data, y = ~predicted_linear_perc1RM, x = ~nRM,
            hoverinfo = "text", opacity = 0.9, marker = list(color = "#60BD68", size = 10),
            text = ~ paste(
              "Linear prediction\n",
              paste("%1RM =", round(predicted_linear_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_markers(
            data = observed_data, y = ~predicted_generic_perc1RM, x = ~nRM,
            hoverinfo = "text", opacity = 0.5, marker = list(color = "grey", size = 10),
            text = ~ paste(
              "Generic Epley's model\n",
              paste("%1RM =", round(predicted_generic_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_epley_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "#FAA43A"), opacity = 0.9,
            text = ~ paste(
              "Epley's model\n",
              paste("%1RM =", round(predicted_epley_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_epley_mod_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "#5DA5DA"), opacity = 0.9,
            text = ~ paste(
              "Modified Epley's model\n",
              paste("%1RM =", round(predicted_epley_mod_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_linear_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "#60BD68"), opacity = 0.9,
            text = ~ paste(
              "Linear model\n",
              paste("%1RM =", round(predicted_linear_perc1RM, 2), "\n"),
              paste("Reps =", round(nRM, 2))
            )
          ) %>%
          add_lines(
            data = model_predictions_df, y = ~predicted_generic_perc1RM, x = ~nRM,
            hoverinfo = "text", line = list(color = "grey", dash = "dash"), opacity = 0.5,
            text = ~ paste(
              "Generic Epley's model\n",
              paste("%1RM =", round(predicted_generic_perc1RM, 2), "\n"),
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

      # Return list object
      list(
        observed_data = observed_data,
        observed_1RM_value = observed_1RM_value,
        model_params = model_params,
        model_performance = model_performance,
        model_characteristics = model_characteristics,
        epley_k = epley_k,
        epley_kmod = epley_kmod,
        linear_klin = linear_klin,
        model_predictions_df =  model_predictions_df,
        plotly_plot = plotly_plot
      )
    },
    ignoreNULL = FALSE
  )


  # Model performance table
  output$single_athlete_model_performance <- renderDataTable({
    model_characteristics <- single_athlete_model()$model_characteristics
    DT::datatable(
      model_characteristics,
      rownames = FALSE, selection = "none",
      options = list(
        searching = FALSE,
        ordering = FALSE,
        paging = FALSE,
        info = FALSE
      )
    )
  })

  # Model graph
  output$single_athlete_model_plot <- renderPlotly({
    single_athlete_model()$plotly_plot
  })

}


#################################################
# Run the application
#################################################

shinyApp(ui = ui, server = server)
