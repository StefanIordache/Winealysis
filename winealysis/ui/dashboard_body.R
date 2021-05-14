dashboard_body <- function() {
  
  dashboard_body <- dashboardBody(
    tags$head(tags$link(rel = "stylesheet", 
                        type = "text/css", 
                        href = "css/custom-styles.css")),
    tags$head(tags$link(rel = "icon", 
                        href = "media/grape-wine.png")),
    tabItems(
      tab_dataset(),
      tab_world_wine_web(),
      tab_cheap_expensive()
    )
  )
  
  dashboard_body
  
}