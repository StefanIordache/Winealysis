tab_cheap_expensive <- function() {
  
  tab_world_wine_web <- tabItem(
    tabName = "cheap-expensive",
    h2("Cheap or Expensive: Wine Price Prediction"),
    br(),
    hr(),
    br(),
    fluidRow(
      box(title = "Price predictor", 
          width = 12, 
          background = "teal",
          fluidRow(
            column(width = 3,
                   offset = 1,
                   uiOutput("predictor_selector_region")
            ),
            column(width = 3,
                   offset = 1,
                   uiOutput("predictor_selector_variety")
            ),
            column(width = 3,
                   offset = 1,
                   uiOutput("predictor_selector_score")
            ),
          ),
          br(),
          fluidRow(
            column(width = 5,
                   p("")),
            column(width = 2,
                   actionButton("predict_price", "Predict price")),
            column(width = 5,
                   p(""))
            
          ),
          br(),
          fluidRow(
            column(width = 5,
                   p("")),
            column(width = 2,
                   textOutput("predicted_price")),
            column(width = 5,
                   p(""))
            
          )
          
      )
    )
  )
  
  tab_world_wine_web
  
}