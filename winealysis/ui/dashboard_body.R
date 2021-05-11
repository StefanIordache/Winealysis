dashboard_body <- function() {
  
  dashboard_body <- dashboardBody(
    tags$head(tags$link(rel = "stylesheet", 
                        type = "text/css", 
                        href = "css/custom-styles.css")),
    tags$head(tags$link(rel = "icon", 
                        href = "media/grape-wine.png")),
    tabItems(
      tab_dataset(),
      tabItem(tabName = "world-wine-web",
              h2("World Wine Web")),
      tabItem(tabName = "cheap-expensive",
              h2("Cheap or Expensive: Wine Price Prediction"))
    )
  )
  
  dashboard_body
  
}