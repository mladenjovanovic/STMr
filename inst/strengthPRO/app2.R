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
          ), # Single Athlete Data Entry
          box(
            title = "Progression Table Settings",
            width = 12,
            collapsible = TRUE,
            background = "light-blue",
            fluidRow(
              column(
                4,
                selectInput(
                  "single_athlete_settings_model",
                  label = "Model",
                  choices = c("Epley's", "Modified Epley's", "Linear"),
                  selected = 2
                )
              ),
              column(
                4,
                selectInput(
                  "single_athlete_settings_parameters",
                  label = "Parameters",
                  choices = c("Estimated", "Generic", "User provided"),
                  selected = 1
                )
              ),
              column(
                4,
                numericInput(
                  "single_athlete_settings_user_provided_value",
                  label = "User Parameter Value",
                  value = 0.0333, min = 0.001, max = 100, step = 0.0001
                )
              )
            ),
            fluidRow(
              column(
                6,
                selectInput(
                  "single_athlete_settings_progression_table",
                  label = "Progression table",
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
                4,
                selectInput(
                  "single_athlete_settings_progression_table_type",
                  label = "Table type",
                  choices = c(
                    "Grinding",
                    "Ballistic"
                  )
                )
              )
            ),
            br(),
            HTML("<b>Note:</b> Use the above settings to customize progression table you want to use")
          ), # Single Athlete Settings
          box(
            title = "Prediction equation",
            collapsible = TRUE,
            width = 12,
            htmlOutput("single_athlete_prediction_equation"),
            br(),
            HTML("<b>Note:</b> Use the above prediction equation to estimate %1RM needed to be used, given
                 the target number of repetitions, model selected, and adjustment level")
          ), # Single Athlete Prediction equation
          collapsible_tabBox(
            title = "Progression Table", width = 12,
            # Reps Max Table
            tabPanel(
              title = "Reps-Max Table",
              fluidPage(
                dataTableOutput("single_athlete_reps_max_table"),
                br(), br(),
                HTML("<b>Note:</b> Reps-max table representes estimated %1RM for a target repetitions and
                     selected adjustment, given the model used")
              )
            ), # Reps Max Table Panel
            # Adjustments
            tabPanel(
              title = "Progressions Adjustments",
              fluidPage(
                column(
                  4,
                  h5("Intensive variant"),
                  dataTableOutput("single_athlete_progression_table_intensive_adjustment")
                ),
                column(
                  4,
                  h5("Normal variant"),
                  dataTableOutput("single_athlete_progression_table_normal_adjustment")
                ),
                column(
                  4,
                  h5("Extensive variant"),
                  dataTableOutput("single_athlete_progression_table_extensive_adjustment")
                ),
                br(), br(),
                HTML("<b>Note:</b> Negative numbers in the columns represent progression steps
                     as defined by a selected progression table model. Numbers in cells represent
                     adjustments to be utilized for the calculus of the %1RM")
              )
            ), # Adjustments
            # Progression %1RMs
            tabPanel(
              title = "Progressions %1RM",
              fluidPage(
                column(
                  4,
                  h5("Intensive variant"),
                  dataTableOutput("single_athlete_progression_table_intensive_perc1RM")
                ),
                column(
                  4,
                  h5("Normal variant"),
                  dataTableOutput("single_athlete_progression_table_normal_perc1RM")
                ),
                column(
                  4,
                  h5("Extensive variant"),
                  dataTableOutput("single_athlete_progression_table_extensive_perc1RM")
                ),
                br(), br(),
                HTML("<b>Note:</b> Negative numbers in the columns represent progression steps
                     as defined by a selected progression table model. Numbers in cells represent
                     estimated %1RM to be used")
              )
            ) # Progression %1RMs
          ), # Progression Tab box
          collapsible_tabBox(
            title = "Set and Rep Schemes", width = 12,
            # Generic
            tabPanel(
              title = "Example",
              fluidPage(
                dataTableOutput("single_athlete_progression_table_example_scheme")
              )
            ), # Examples tab
            tabPanel(
              title = "Custom Set and Rep Scheme",
              fluidPage(
                column(
                  3,
                  h5("When entering numerics use ',' to delimitate (e.g., '5, 3, 1')"),
                  textInput(
                    "single_athlete_example_schemes_reps",
                    "Reps",
                    value = "5, 5, 5, 5",
                  ),
                  textInput(
                    "single_athlete_example_schemes_adjustment",
                    "Extra Adjustment",
                    value = "0"
                  ),
                  h6("Use DI, RI, RIR, %MR as extra adjustment to be added to progression table. Value depends on the selected progression table. This will affect the calculation of the %1RM"),
                  br(),
                  textInput(
                    "single_athlete_example_schemes_adjustment_in_perc1RM",
                    "Extra Adjustment in %1RM",
                    value = "0"
                  ),
                  h6("Use extra adjustment to be added to estimated %1RM (after everything is calculated)"),
                  br(),
                  selectInput(
                    "single_athlete_example_schemes_volume",
                    "Volume",
                    choices = c("Intensive", "Normal", "Extensive"), selected = "Normal"
                  ),
                  br(),
                  textInput(
                    "single_athlete_example_schemes_reps_change",
                    "Reps change",
                    value = ""
                  ),
                  h6("How should reps change across progression steps?"),
                  br(),
                  textInput(
                    "single_athlete_example_schemes_steps",
                    "Steps",
                    value = "-3, -2, -1, 0"
                  ),
                  h6("Enter progression steps to be utilized. If empty, number of 'reps change' items will be used"),
                  br(),
                  textInput(
                    "single_athlete_example_schemes_reps_adjustment",
                    "Reps adjustment",
                    value = ""
                  ),
                  h6("Extra adjustment for the reps after everything is calculated"),
                  # actionButton("schemes_generate_button", "Generate", class = "btn-success", icon = icon("hourglass-start"))
                ),
                column(
                  1
                ),
                column(
                  8,
                  checkboxInput(
                    "single_athlete_example_schemes_include_adjustment",
                    "Include Adjustment info?",
                    value = TRUE
                  ),
                  dataTableOutput("single_athlete_example_schemes_generate_scheme_table"),
                  br(),
                  br(),
                  plotOutput("single_athlete_example_schemes_generate_scheme", height = "600px", width = "800px") # Plot generate scheme
                )
              )
            )
          ), # Single Athlete Examples
          box(
            title = "Report",
            collapsible = TRUE,
            width = 12,
            downloadButton(
              "single_athlete_report_button",
              "Generate Excel Report",
              class = "btn-large btn-success",
              icon = icon("hourglass-start")
            )
          ),
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
        model_predictions_df = model_predictions_df,
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

  #############################################
  # Progression Tables
  ############################################

  single_athlete_progression_table <- reactive({

    # Options from the GUI
    model_used <- input$single_athlete_settings_model
    parameters <- input$single_athlete_settings_parameters
    user_value <- input$single_athlete_settings_user_provided_value
    progression_table <- input$single_athlete_settings_progression_table
    progression_table_type <- input$single_athlete_settings_progression_table_type

    # Estimates
    model_estimates <- single_athlete_model()

    # Get the parameter value
    if (parameters == "Generic") {
      parameter_value <- switch(model_used,
        "Epley's" = 0.0333,
        "Modified Epley's" = 0.0353,
        "Linear" = 33
      )
    } else if (parameters == "User provided") {
      parameter_value <- user_value
    } else if ((parameters == "Estimated")) {
      parameter_value <- switch(model_used,
        "Epley's" = model_estimates$epley_k,
        "Modified Epley's" = model_estimates$epley_kmod,
        "Linear" = model_estimates$linear_klin
      )
    }

    # Prediction equation
    prediction_equation <- ""

    eq_parameter_value <- switch(model_used,
      "Epley's" = round(parameter_value, 4),
      "Modified Epley's" = round(parameter_value, 4),
      "Linear" = round(parameter_value, 1)
    )

    # RIR
    k_RIR_grinding <- "%%1RM = 1 / (%g * (Reps + RIR) + 1)"
    k_RIR_ballistic <- "%%1RM = 1 / (2 * %g * (Reps + RIR) + 1)"

    kmod_RIR_grinding <- "%%1RM = 1 / (%g * (Reps + RIR - 1) + 1)"
    kmod_RIR_ballistic <- "%%1RM = 1 / (%g * (2 * Reps + 2 * RIR - 1) + 1)"

    klin_RIR_grinding <- "%%1RM = (-RIR + %g - Reps + 1) / %g"
    klin_RIR_ballistic <- "%%1RM = (-2 * RIR + %g - 2 * Reps + 1) / %g"

    # DI
    k_DI_grinding <- "%%1RM = 1 / (%g * Reps + 1) - DI"
    k_DI_ballistic <- "%%1RM = 1 / (2 * %g * Reps + 1) - DI"

    kmod_DI_grinding <- "%%1RM = 1 / (%g * (Reps - 1) + 1) - DI"
    kmod_DI_ballistic <- "%%1RM = 1 / (%g * (2 * Reps - 1) + 1) - DI"

    klin_DI_grinding <- "%%1RM = (%g - Reps + 1) / %g - DI"
    klin_DI_ballistic <- "%%1RM = (%g - 2 * Reps + 1) / %g - DI"

    # Relative Intensity
    k_relInt_grinding <- "%%1RM = RI / (%g * Reps + 1)"
    k_relInt_ballistic <- "%%1RM = RI / (2 * %g * Reps + 1)"

    kmod_relInt_grinding <- "%%1RM = RI / (%g * (Reps - 1) + 1)"
    kmod_relInt_ballistic <- "%%1RM = RI / (%g * (2 * Reps - 1) + 1)"

    klin_relInt_grinding <- "%%1RM = RI * (%g - Reps + 1) / %g"
    klin_relInt_ballistic <- "%%1RM = RI * (%g - 2 * Reps + 1) / %g"

    # %%MR
    k_percMR_grinding <- "%%1RM = %%MR / (%%MR + %g * Reps)"
    k_percMR_ballistic <- "%%1RM = %%MR / (%%MR + 2 * %g * Reps)"

    kmod_percMR_grinding <- "%%1RM = 1 / (%g * (Reps / %%MR - 1) + 1)"
    kmod_percMR_ballistic <- "%%1RM = 1 / (%g * (2 * Reps / %%MR - 1) + 1)"

    klin_percMR_grinding <- "%%1RM = (%g - Reps / %%MR + 1) / %g"
    klin_percMR_ballistic <- "%%1RM = (%g - 2 * Reps / %%MR + 1) / %g"

    if (progression_table_type == "Grinding") {
      if (model_used == "Epley's") {
        print_text <- switch(progression_table,
          "Deducted Intensity 2.5%" = k_DI_grinding,
          "Deducted Intensity 5%" = k_DI_grinding,
          "Relative Intensity" = k_relInt_grinding,
          "Perc Drop" = k_DI_grinding,
          "RIR 1" = k_RIR_grinding,
          "RIR 2" = k_RIR_grinding,
          "RIR Inc" = k_RIR_grinding,
          "%MR Step Const" = k_percMR_grinding,
          "%MR Step Var" = k_percMR_grinding
        )
      } else if (model_used == "Modified Epley's") {
        print_text <- switch(progression_table,
          "Deducted Intensity 2.5%" = kmod_DI_grinding,
          "Deducted Intensity 5%" = kmod_DI_grinding,
          "Relative Intensity" = kmod_relInt_grinding,
          "Perc Drop" = kmod_DI_grinding,
          "RIR 1" = kmod_RIR_grinding,
          "RIR 2" = kmod_RIR_grinding,
          "RIR Inc" = kmod_RIR_grinding,
          "%MR Step Const" = kmod_percMR_grinding,
          "%MR Step Var" = kmod_percMR_grinding
        )
      } else if (model_used == "Linear") {
        print_text <- switch(progression_table,
          "Deducted Intensity 2.5%" = klin_DI_grinding,
          "Deducted Intensity 5%" = klin_DI_grinding,
          "Relative Intensity" = klin_relInt_grinding,
          "Perc Drop" = klin_DI_grinding,
          "RIR 1" = klin_RIR_grinding,
          "RIR 2" = klin_RIR_grinding,
          "RIR Inc" = klin_RIR_grinding,
          "%MR Step Const" = klin_percMR_grinding,
          "%MR Step Var" = klin_percMR_grinding
        )
      }
    } else { # Ballistic
      if (model_used == "Epley's") {
        print_text <- switch(progression_table,
          "Deducted Intensity 2.5%" = k_DI_ballistic,
          "Deducted Intensity 5%" = k_DI_ballistic,
          "Relative Intensity" = k_relInt_ballistic,
          "Perc Drop" = k_DI_ballistic,
          "RIR 1" = k_RIR_ballistic,
          "RIR 2" = k_RIR_ballistic,
          "RIR Inc" = k_RIR_ballistic,
          "%MR Step Const" = k_percMR_ballistic,
          "%MR Step Var" = k_percMR_ballistic
        )
      } else if (model_used == "Modified Epley's") {
        print_text <- switch(progression_table,
          "Deducted Intensity 2.5%" = kmod_DI_ballistic,
          "Deducted Intensity 5%" = kmod_DI_ballistic,
          "Relative Intensity" = kmod_relInt_ballistic,
          "Perc Drop" = kmod_DI_ballistic,
          "RIR 1" = kmod_RIR_ballistic,
          "RIR 2" = kmod_RIR_ballistic,
          "RIR Inc" = kmod_RIR_ballistic,
          "%MR Step Const" = kmod_percMR_ballistic,
          "%MR Step Var" = kmod_percMR_ballistic
        )
      } else if (model_used == "Linear") {
        print_text <- switch(progression_table,
          "Deducted Intensity 2.5%" = klin_DI_ballistic,
          "Deducted Intensity 5%" = klin_DI_ballistic,
          "Relative Intensity" = klin_relInt_ballistic,
          "Perc Drop" = klin_DI_ballistic,
          "RIR 1" = klin_RIR_ballistic,
          "RIR 2" = klin_RIR_ballistic,
          "RIR Inc" = klin_RIR_ballistic,
          "%MR Step Const" = klin_percMR_ballistic,
          "%MR Step Var" = klin_percMR_ballistic
        )
      }
    }

    if (model_used == "Linear") {
      prediction_equation <- sprintf(print_text, eq_parameter_value, eq_parameter_value)
    } else {
      prediction_equation <- sprintf(print_text, eq_parameter_value)
    }

    # Function factory for the reps-max equation
    get_max_perc_1RM_RIR_func <- switch(model_used,
      "Epley's" = function(...) get_max_perc_1RM_k(..., k = parameter_value),
      "Modified Epley's" = function(...) get_max_perc_1RM_kmod(..., kmod = parameter_value),
      "Linear" =  function(...) get_max_perc_1RM_klin(..., klin = parameter_value)
    )

    get_max_perc_1RM_relInt_func <- switch(model_used,
      "Epley's" = function(...) get_max_perc_1RM_k_relInt(..., k = parameter_value),
      "Modified Epley's" = function(...) get_max_perc_1RM_kmod_relInt(..., kmod = parameter_value),
      "Linear" =  function(...) get_max_perc_1RM_klin_relInt(..., klin = parameter_value)
    )

    get_max_perc_1RM_percMR_func <- switch(model_used,
      "Epley's" = function(...) get_max_perc_1RM_k_percMR(..., k = parameter_value),
      "Modified Epley's" = function(...) get_max_perc_1RM_kmod_percMR(..., kmod = parameter_value),
      "Linear" =  function(...) get_max_perc_1RM_klin_percMR(..., klin = parameter_value)
    )

    get_max_perc_1RM_DI_func <- switch(model_used,
      "Epley's" = function(..., adjustment) get_max_perc_1RM_k(..., k = parameter_value) + adjustment,
      "Modified Epley's" = function(..., adjustment) get_max_perc_1RM_kmod(..., kmod = parameter_value) + adjustment,
      "Linear" =  function(..., adjustment) get_max_perc_1RM_klin(..., klin = parameter_value) + adjustment
    )

    # Function factory for the progression table
    progression_table_func <- switch(progression_table,
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

    adjustment_seq <- switch(progression_table,
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

    adjustment_values <- switch(progression_table,
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

    get_max_perc_1RM_func <- switch(progression_table,
      "Deducted Intensity 2.5%" = get_max_perc_1RM_DI_func,
      "Deducted Intensity 5%" = get_max_perc_1RM_DI_func,
      "Relative Intensity" = get_max_perc_1RM_relInt_func,
      "Perc Drop" = get_max_perc_1RM_DI_func,
      "RIR 1" = get_max_perc_1RM_RIR_func,
      "RIR 2" = get_max_perc_1RM_RIR_func,
      "RIR Inc" = get_max_perc_1RM_RIR_func,
      "%MR Step Const" = get_max_perc_1RM_percMR_func,
      "%MR Step Var" = get_max_perc_1RM_percMR_func
    )

    reps_max_tbl <- expand_grid(
      Reps = seq(1, 12),
      data.frame(adjustment = adjustment_seq, adjustment_val = adjustment_values)
    ) %>%
      mutate(
        perc_1RM = round(
          100 * get_max_perc_1RM_func(
            max_reps = Reps,
            adjustment = adjustment,
            type = tolower(progression_table_type)
          ),
          1
        )
      ) %>%
      pivot_wider(id_cols = Reps, names_from = adjustment_val, values_from = perc_1RM)

    # Progression table
    progression_table_long<- generate_progression_table(
      progression_table = progression_table_func,
      type = tolower(progression_table_type),
      reps = 1:12,
      step = c(-3, -2, -1, 0)
    ) %>%
      mutate(
        perc_1RM = round(100 * perc_1RM, 1),
        adjustment = switch(progression_table,
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
        step = step # length(unique(step)) + step
      ) %>%
      rename(Step = step, Reps = reps)

    # Convert to wide
    # %1RM
    progression_table_intensive_perc1RM <- progression_table_long%>%
      filter(volume == "intensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = perc_1RM)

    progression_table_normal_perc1RM <- progression_table_long%>%
      filter(volume == "normal") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = perc_1RM)

    progression_table_extensive_perc1RM <- progression_table_long%>%
      filter(volume == "extensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = perc_1RM)

    # Adjustments
    progression_table_intensive_adjustment <- progression_table_long%>%
      filter(volume == "intensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = adjustment)

    progression_table_normal_adjustment <- progression_table_long%>%
      filter(volume == "normal") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = adjustment)

    progression_table_extensive_adjustment <- progression_table_long%>%
      filter(volume == "extensive") %>%
      pivot_wider(id_cols = Reps, names_from = Step, values_from = adjustment)

    # Return object
    list(
      parameter_value = parameter_value,
      prediction_equation = prediction_equation,
      progression_table_func = progression_table_func,
      get_max_perc_1RM_func = get_max_perc_1RM_func,
      reps_max_tbl = reps_max_tbl,
      progression_table_long = progression_table_long,
      progression_table_type = progression_table_type,
      progression_table_intensive_perc1RM = progression_table_intensive_perc1RM,
      progression_table_normal_perc1RM = progression_table_normal_perc1RM,
      progression_table_extensive_perc1RM = progression_table_extensive_perc1RM,
      progression_table_intensive_adjustment = progression_table_intensive_adjustment,
      progression_table_normal_adjustment = progression_table_normal_adjustment,
      progression_table_extensive_adjustment = progression_table_extensive_adjustment
    )
  })

  # Print prediction equation
  output$single_athlete_prediction_equation <- renderText({
    paste0("<b>", single_athlete_progression_table()$prediction_equation, "</b>")
  })

  # Reps-max table
  output$single_athlete_reps_max_table <- renderDT({
    reps_max_tbl <- single_athlete_progression_table()$reps_max_tbl

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

  # Progression Table adjustments
  output$single_athlete_progression_table_intensive_adjustment <- renderDT({

    DT::datatable(
      single_athlete_progression_table()$progression_table_intensive_adjustment,
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

  output$single_athlete_progression_table_normal_adjustment <- renderDT({

    DT::datatable(
      single_athlete_progression_table()$progression_table_normal_adjustment,
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

  output$single_athlete_progression_table_extensive_adjustment <- renderDT({

    DT::datatable(
      single_athlete_progression_table()$progression_table_extensive_adjustment,
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

  # Progression Table %1RM
  output$single_athlete_progression_table_intensive_perc1RM <- renderDT({

    DT::datatable(
      single_athlete_progression_table()$progression_table_intensive_perc1RM,
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

  output$single_athlete_progression_table_normal_perc1RM <- renderDT({

    DT::datatable(
      single_athlete_progression_table()$progression_table_normal_perc1RM,
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

  output$single_athlete_progression_table_extensive_perc1RM <- renderDT({

    DT::datatable(
      single_athlete_progression_table()$progression_table_extensive_perc1RM,
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

  ############################################
  #  Generic Examples
  ###########################################

  single_athlete_generic_example <- reactive({
    progression_table <- single_athlete_progression_table()

    # Generic example
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
          `Step 2-1 Diff` = round(`Step 2` - `Step 1`, 2),
          `Step 3-2 Diff` = round(`Step 3` - `Step 2`, 2),
          `Step 4-3 Diff` = round(`Step 4` - `Step 3`, 2)
        )

      example_data_wide
    }

    generic_example <- create_example(
      progression_table$progression_table_func,
      type = tolower(progression_table$progression_table_type))

    # Return object
    generic_example

  })


  # Example schemes
  output$single_athlete_progression_table_example_scheme <- renderDT({
    example_schemes <- single_athlete_generic_example()

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

  ############################################
  #  Custom Scheme
  ###########################################

  single_athlete_custom_scheme <- reactive({

  })

}


#################################################
# Run the application
#################################################

shinyApp(ui = ui, server = server)
