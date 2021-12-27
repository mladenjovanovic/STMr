library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)

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
          box(
            title = "Known 1RM",
            id = "data_entry_known_1RM",
            width = 6,
            numericInput("data_entry_known_1RM_value", label = "1RM", value = 150, min = 0, max = 1000, step = 1),
            br(),
            DTOutput("data_entry_known_1RM_table"),
            br(),
            actionButton("data_entry_known_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start")),
            tableOutput("test_known")
          ), # Box Known 1RM
          box(
            title = "Estimate 1RM",
            id = "data_entry_estimate_1RM",
            width = 6,
            DTOutput("data_entry_estimate_1RM_table"),
            br(),
            actionButton("data_entry_estimate_1RM_button", "Model", class = "btn-success", icon = icon("hourglass-start")),
            tableOutput("test")
          ) # Box Estimate 1RM
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
        Weight = c(120, 100, 80, NA, NA),
        Reps = c(3, 5, 10, NA, NA),
        eRIR = c(0, 0, 0, NA, NA))
  })

  output$data_entry_known_1RM_table <- renderDT({
    DT::datatable(
      known_1RM_table$data,
      rownames = FALSE, selection = "none",
      editable = list(
        target = "cell",
        #disable = list(columns = c(1)),
        numeric = c(1, 2)),
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
    info = input$data_entry_known_1RM_table_cell_edit
    i = as.numeric(info$row)
    j = as.numeric(info$col) + 1
    k = as.numeric(info$value)

    # write values to reactive
    known_1RM_table$data[i,j] <- k
  })

  # ========================
  # Estimate 1RM entry table
  estimate_1RM_table <- reactiveValues(data = {
    data.frame(Weight = numeric(0), Reps = numeric(0), eRIR = numeric(0)) %>%
      add_row(
        Weight = c(120, 100, 80, NA, NA),
        Reps = c(3, 5, 10, NA, NA),
        eRIR = c(0, 0, 0, NA, NA))
  })

  output$data_entry_estimate_1RM_table <- renderDT({
    DT::datatable(
      estimate_1RM_table$data,
      rownames = FALSE, selection = "none",
      editable = list(
        target = "cell",
        #disable = list(columns = c(1)),
        numeric = c(1, 2)),
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
    info = input$data_entry_estimate_1RM_table_cell_edit
    i = as.numeric(info$row)
    j = as.numeric(info$col) + 1
    k = as.numeric(info$value)

    # write values to reactive
    estimate_1RM_table$data[i,j] <- k
  })

  output$test <- renderTable({
    estimate_1RM_table$data
  })

  output$test_known <- renderTable({
    known_1RM_table$data
  })
}

# Run the application
shinyApp(ui = ui, server = server)
