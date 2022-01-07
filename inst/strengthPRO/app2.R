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
          tabName = "menu-item-single-athlete"
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
}


#################################################
# Run the application
#################################################

shinyApp(ui = ui, server = server)
