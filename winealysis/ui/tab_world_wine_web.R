tab_world_wine_web <- function() {
  
  tab_world_wine_web <- tabItem(
    tabName = "world-wine-web",
    h2("World Wine Web - average quality of wine by each country"),
    br(),
    hr(),
    br(),
    fluidRow(
      column(width = 6,
             offset = 3,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("points_countries_map"))
             )
      )
    )
  )
  
  tab_world_wine_web
  
}