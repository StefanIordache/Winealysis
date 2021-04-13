library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(bslib)

ui <- dashboardPage (
    md = TRUE,
    skin = "midnight",
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody()
)

server <- function(input, output) {
    
}

shinyApp(ui, server)
