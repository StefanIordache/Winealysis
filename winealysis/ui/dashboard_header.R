dashboard_header <- function() {
  
  dashboard_header <- dashboardHeader()
  dashboard_header$children[[2]]$children <- tags$a(href='/', 
                                                    tags$img(src='media/grape-wine.png', 
                                                             height = 60, 
                                                             width = 60))
  
  dashboard_header
  
}