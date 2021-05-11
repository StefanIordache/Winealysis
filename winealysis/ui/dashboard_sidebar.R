dashboard_sidebar <- function() {
  
  dashboard_sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("The Dataset", 
               tabName = "dataset", 
               icon = icon("chart-bar")),
      menuItem("World Wine Web", 
               tabName = "world-wine-web", 
               icon = icon("globe")),
      menuItem("Cheap or Expensive?", 
               tabName = "cheap-expensive", 
               icon = icon("search-dollar"))
    )
  )
  
  dashboard_sidebar
  
}