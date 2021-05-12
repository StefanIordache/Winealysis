tab_dataset <- function() {
  
  tab_dataset <- tabItem(
    tabName = "dataset",
    h2("Bottles in Numbers: Exploring the Dataset"),
    br(),
    hr(),
    br(),
    h3("Rows & Columns"),
    fluidRow(
      box(
        title = "Features List", width = 4, solidHeader = TRUE,
        tags$ul(
          tags$li(tags$b("Country"), " - text"),
          tags$li(tags$b("Description"), " - text"),
          tags$li(tags$b("Designation"), " - text"),
          tags$li(tags$b("Points"), " - numeric"),
          tags$li(tags$b("Price"), " - numeric"),
          tags$li(tags$b("Province"), " - text"),
          tags$li(tags$b("Region 1"), " - text"),
          tags$li(tags$b("Region 2"), " - text"),
          tags$li(tags$b("Taster Name"), " - text"),
          tags$li(tags$b("Winery"), " - text"),
          tags$li(tags$b("Variety"), " - text"),
          tags$li(tags$b("Title"), " - text"),
        )
      ),
      column(
        shinycssloaders::withSpinner(
          image = "media/wine-loading-animation-transparent.gif",
          image.width = 200,
          image.height = 200,
          ui_element = list(uiOutput("dataset_nr_columns"), 
                            uiOutput("dataset_nr_rows"),
                            uiOutput("dataset_nr_columns_integer"), 
                            uiOutput("dataset_nr_columns_character"))
          ),
          width = 8
        ),
      ),
    br(),
    hr(),
    br(),
    h3("Wines Price Distribution - Price & Probability + Mean"),
    br(),
    fluidRow(
      column(width = 8, 
             offset = 2,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("dataset_wines_price_distribution"),
                                 p("There is no such thing as expensive wine when it comes to casual consumers. Exaggerated prices are available only to special bottles, based on rarity, flavour and quantity!"))
               )
             )
    ),
    hr(),
    br(),
    h3("Wines Points Distribution - Points & Probability + Mean"),
    br(),
    fluidRow(
      column(width = 8, 
             offset = 2,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("dataset_wines_points_distribution"),
                                 p("The distribution of points looks like a normal distribution and this observation proves that this dataset is close to reality since we cannot drink always the best or the worst bottles of wines.")
               )
             )
      )
    ),
    hr(),
    br(),
    h3("Infographics"),
    br(),
    h4("1. Geo exploration"),
    br(),
    fluidRow(
      column(width = 8,
             offset = 2,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("top_10_countries_distribution"),
                                 p("The dataset provider, WineEnthusiast website is an US-based publication and there is no surprise in the fact that America is still number one in this top. The reality of the world situation is reflected by the presence of other countries like Italy, France, Spain and Portugal."))
             )
      )
    ),
    br(),
    fluidRow(
      column(width = 4,
             offset = 1,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("countries_points_boxplot"))
             )
      ),
      column(width = 4,
             offset = 2,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("countries_prices_boxplot"))
             )
      )
    ),
    br(),
    fluidRow(
      column(width = 6,
             offset = 3,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(wordcloud2Output("countries_wordcloud"))
             )
      )
    ),
    br(),
    h4("2. Tasters exploration"),
    br(),
    fluidRow(
      column(width = 8,
             offset = 2,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("top_tasters_distribution"),
                                 p("There seems to be lots of anonymous reviewers, which is a good aspect of the dataset. But, there are some reviewers with high percentage of the total number of reviews meaning that it will add bias to descriptions and data."))
             )
      )
    ),
    br(),
    fluidRow(
      column(width = 10,
             offset = 1,
             shinycssloaders::withSpinner(
               image = "media/wine-loading-animation-transparent.gif",
               image.width = 200,
               image.height = 200,
               ui_element = list(plotlyOutput("top_5_tasters_country_distribution"),
                                 p("As we can see, there is a good distribution of reviews by each reviewer on different countries."))
             )
      )
    )
  )
  
  tab_dataset
  
}