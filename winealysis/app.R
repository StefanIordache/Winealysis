library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(bslib)

source(paste0("utils/load_packages.R"))
source(paste0("ui/load_ui_modules.R"))


ui <- dashboardPage (
    md = TRUE,
    skin = "midnight",
    dashboard_header(),
    dashboard_sidebar(),
    dashboard_body()
)

server <- function(input, output) {
    set.seed(123)
    
    showModal(modalDialog(
        title = "", 
        h1('Winealysis'),
        p('Discover the world behind the doors of the most famous wine cellars! '),
        img(src="media/wine-loading-animation.gif"),
        footer = tagList(
            modalButton('Start the adventure!')
        )
    ))
    
    output$predicted_price <- renderText({ 
        "Recommended price: 0 $"
    })
    
    predictor_features <- read.csv("data/predictor-features.csv")
        
    output$predictor_selector_region <- renderUI({
        
        data <- predictor_features
        
        selectInput("region_predictor", 
                    label = tags$span(style="color: black;", "Region"),
                    choices = c(data[data$Region != "", ]$Region))
    })
    
    output$predictor_selector_variety <- renderUI({
        
        data <- predictor_features
        
        selectInput("variety_predictor", 
                    label = tags$span(style="color: black;", "Variety"),
                    choices = c(data[data$Variety != "", ]$Variety))
    })
    
    output$predictor_selector_score <- renderUI({
        
        data <- predictor_features
        
        selectInput("score_predictor",
                    label = tags$span(style="color: black;", "Score"),
                    choices = c(data[!is.na(data$Score), ]$Score))
    })
    
    observeEvent(input$predict_price, {
        
        features_list <- integer(1147)
        
        features_list[which(predictor_features$Region == input$region_predictor)] <- 1
        features_list[426 + which(predictor_features$Variety == input$variety_predictor)] <- 1
        features_list[1127 + which(as.character(predictor_features$Score) == as.character(input$score_predictor))] <- 1
        
        args <-  list(features = features_list)
        
        res = POST("https://us-central1-third-container-310616.cloudfunctions.net/function-predict",
                  body = toJSON(args, auto_unbox = TRUE),
                  add_headers (
                      "Content-Type" = "application/json"
                  ))
        
        data_returned = fromJSON(rawToChar(res$content))
        
        output$predicted_price <- renderText({ 
                paste0("Recommened price: ", as.character(data_returned), " $")
            })
    })
    
    
    dataset <- reactive({
        csv_dataset <- read.csv("data/winemag-130k.csv")
        
        clean_dataset <- csv_dataset %>% 
            mutate(duplicated_description = duplicated(description)) %>% 
            filter(duplicated_description == FALSE) %>% 
            select(-duplicated_description)
        
        clean_dataset
    })
    
    output$dataset_nr_columns <- renderUI({
        valueBox(dim(dataset())[2], "Columns", icon = icon("arrow-right"), width = 6)
    })
    
    output$dataset_nr_rows <- renderUI({
        valueBox(dim(dataset())[1], "Rows", icon = icon("arrow-down"), width = 6)
    })
    
    output$dataset_nr_columns_integer <- renderUI({
        n <- sum(unname(sapply(dataset(), typeof)) == "integer")
        infoBox("Numeric Columns", n, icon = icon("sort-numeric-up-alt"), width = 6)
    })
    
    output$dataset_nr_columns_character <- renderUI({
        n <-sum(unname(sapply(dataset(), typeof)) == "character")
        infoBox("Text Columns", n, icon = icon("font"), width = 6)
    })
    
    output$dataset_wines_price_distribution <- renderPlotly({
        data <- dataset()
        
        wines_price_distribution <- data %>% 
            ggplot(aes(x = price)) +
            geom_histogram(aes(y = ..density..), fill = 'pink', colour = 'darkred', bins = 100) +
            geom_vline(aes(xintercept = mean(points)), color = "yellow", linetype="dashed", size = 1) + 
            theme_minimal() +
            labs(x = 'Price', y = 'Probability') +
            theme(
                plot.background = element_rect(fill = "#353c42"), 
                panel.background = element_rect(fill = "#353c42", colour="#353c42"),
                axis.text.x = element_text(colour  = "white"),
                axis.text.y = element_text(colour  = "white"),
                axis.title.x = element_text(colour  = "white"),
                axis.title.y = element_text(colour  = "white")
            )
        
        ggplotly(wines_price_distribution)
    })
    
    output$dataset_wines_points_distribution <- renderPlotly({
        data <- dataset()
        
        wines_points_distribution <- data %>% 
            ggplot(aes(x = points)) +
            geom_histogram(aes(y = ..density..), fill = 'lightblue', colour = "darkblue", bins = 21, template = "seaborn") +
            geom_vline(aes(xintercept = mean(points)), color = "yellow", linetype="dashed", size = 1) + 
            theme_minimal() +
            labs(x = 'Points', y = 'Probability') +
            theme(
                plot.background = element_rect(fill = "#353c42"), 
                panel.background = element_rect(fill = "#353c42", colour="#353c42"),
                axis.text.x = element_text(colour  = "white"),
                axis.text.y = element_text(colour  = "white"),
                axis.title.x = element_text(colour  = "white"),
                axis.title.y = element_text(colour  = "white")
            )
        
        ggplotly(wines_points_distribution) 
    })
    
    top_10_countries <- reactive({
        data <- dataset()
        
        top_10_countries_dataset <- data %>%
            group_by(country) %>%
            summarise(counter = n()) %>%
            arrange(desc(counter)) %>%
            mutate(counter_percentage = round(counter / sum(counter), digits = 4), counter_accum = cumsum(counter_percentage))
        
        top_10_countries_dataset
    })
    
    output$top_10_countries_distribution <- renderPlotly({
        data <- top_10_countries()
        
        top_10_countries_distribution <- data %>%
            head(10) %>%
            ggplot(aes(x = factor(country, levels = data$country[order(desc(data$counter_percentage))]), y = counter)) +
            geom_col(fill = 'lightblue', colour = "darkblue") + 
            geom_text(aes(label = sprintf("%.1f%%", 100 * counter_percentage), y = counter + 1500), color = "yellow", size = 4) +
            labs(x = "Country", y = "Number of Reviews", title = "Top 10 Countries by Number of Wines Reviewed") +
            theme(
                plot.background = element_rect(fill = "#353c42"), 
                panel.background = element_rect(fill = "#353c42", colour="#353c42"),
                axis.text.x = element_text(colour  = "white", angle = 45),
                axis.text.y = element_text(colour  = "white"),
                axis.title.x = element_text(colour  = "white"),
                axis.title.y = element_text(colour  = "white"),
                plot.title = element_text(colour = "red", size = 10)
            )
        
        ggplotly(top_10_countries_distribution) 
    })
    
    top_tasters <- reactive({
        data <- dataset()
        
        top_tasters_dataset <- data %>%
            group_by(taster_name) %>%
            summarise(counter = n()) %>%
            arrange(desc(counter)) %>%
            mutate(counter_percentage = round(counter / sum(counter), digits = 4), counter_accum = cumsum(counter_percentage))
        
        top_tasters_dataset$taster_name <- factor(top_tasters_dataset$taster_name,
                                          levels = top_tasters_dataset$taster_name[order(-top_tasters_dataset$counter)])
        
        top_tasters_dataset
    })
    
    output$top_tasters_distribution <- renderPlotly({
        data <- top_tasters()
        
        top_tasters_distribution <- data %>%
            ggplot(aes(x = taster_name, y = counter)) + 
            geom_col(fill = 'pink', colour = "darkred") +
            geom_text(aes(label = sprintf("%.f%%", 100 * counter_percentage), y = counter + 2000), color = "pink", size = 2) +
            labs(x = "Taster Name", y = "Number or Reviews", title = "Top Reviewers") + 
            theme(
                plot.background = element_rect(fill = "#353c42"), 
                panel.background = element_rect(fill = "#353c42", colour="#353c42"),
                axis.text.x = element_text(colour  = "white", angle = 90, vjust = 0.5, hjust=1),
                axis.text.y = element_text(colour  = "white"),
                axis.title.x = element_text(colour  = "white"),
                axis.title.y = element_text(colour  = "white"),
                plot.title = element_text(colour = "red", size = 10)
            )
        
        ggplotly(top_tasters_distribution) 
    })
    
    output$top_5_tasters_country_distribution <- renderPlotly({
        data <- top_tasters() %>%
            filter(taster_name != "") %>%
            head(5)
        
        top_10_countries_data <- top_10_countries()
        
        top_tasters_country <- dataset() %>% 
            filter(taster_name %in% data$taster_name) %>%
            group_by(taster_name, country) %>%
            summarise(counter = n())
        
        top_5_tasters_country_distribution <- top_tasters_country %>% 
            ggplot(aes(x = factor(taster_name, levels = data$taster_name[order(-data$counter)]), 
                        y=factor(country, levels = top_10_countries_data$country[order(top_10_countries_data$counter)]), 
                        size = counter)) +
            geom_point(colour = "orange") +
            theme(
                plot.background = element_rect(fill = "#353c42"), 
                panel.background = element_rect(fill = "#353c42", colour="#353c42"),
                axis.text.x = element_text(colour  = "white", angle = 90, vjust = 0.5, hjust=1),
                axis.text.y = element_text(colour  = "white"),
                axis.title.x = element_text(colour  = "white"),
                axis.title.y = element_text(colour  = "white"),
                plot.title = element_text(colour = "red", size = 10)
            ) +
            labs(x = "Taster Name", y = "Country", title = "Reviews Distribution Grouped by Top 5 Tasters & Countries")
        
        ggplotly(top_5_tasters_country_distribution)
    })
    
    output$countries_points_boxplot <- renderPlotly({
        top_10_countries_data <- top_10_countries()
        
        countries_points_boxplot = dataset() %>% 
            filter(country %in% head(top_10_countries_data$country, 10)) %>%
            ggplot(aes(x = country, y = points)) + 
            geom_boxplot(fill = "lightblue", colour = "darkblue") + 
            stat_summary(fun.y = mean, geom = "point", color = I("yellow")) +
            labs(x = "Country", y = "Points", title = "Countries & Points") +
            theme(
                plot.background = element_rect(fill = "#353c42"), 
                panel.background = element_rect(fill = "#353c42", colour="#353c42"),
                axis.text.x = element_text(colour  = "white", angle = 90, vjust = 0.5, hjust=1),
                axis.text.y = element_text(colour  = "white"),
                axis.title.x = element_text(colour  = "white"),
                axis.title.y = element_text(colour  = "white"),
                plot.title = element_text(colour = "red", size = 10)
            )
        ggplotly(countries_points_boxplot)
    })
    
    output$countries_prices_boxplot <- renderPlotly({
        top_10_countries_data <- top_10_countries()
        
        countries_prices_boxplot = dataset() %>% 
            filter(country %in% head(top_10_countries_data$country, 10), price <= 300) %>%
            ggplot(aes(x = country, y = price)) + 
            geom_boxplot(fill = "lightblue", colour = "darkblue") +
            stat_summary(fun.y = mean, geom = "point", color=I("yellow")) +
            labs(x = "Country", y = "Price", title = "Countries & Prices") +
            theme(
                plot.background = element_rect(fill = "#353c42"), 
                panel.background = element_rect(fill = "#353c42", colour="#353c42"),
                axis.text.x = element_text(colour  = "white", angle = 90, vjust = 0.5, hjust=1),
                axis.text.y = element_text(colour  = "white"),
                axis.title.x = element_text(colour  = "white"),
                axis.title.y = element_text(colour  = "white"),
                plot.title = element_text(colour = "red", size = 10)
            )
            
        ggplotly(countries_prices_boxplot)
    })
    
    output$countries_wordcloud <- renderWordcloud2({

        data <- dataset()

        country_names <- Corpus(VectorSource(tolower(data$country)))
        country_names_frequencies = as.data.frame(as.matrix(DocumentTermMatrix(country_names, control = list(wordLengths = c(2, Inf)))))

        countries <- colnames(country_names_frequencies)
        frequencies <- colSums(country_names_frequencies)

        countries_frequencies <- data.frame(countries, frequencies)

        countries_wordcloud <- wordcloud2(countries_frequencies, backgroundColor = "#353c42", minRotation = -pi/2, maxRotation = -pi/2, size = 1.5)

        countries_wordcloud
    })

    # output$regions_wordcloud <- renderWordcloud2({
    # 
    #     data <- dataset()
    # 
    #     region_names <- Corpus(VectorSource(tolower(data$region_1)))
    #     region_names_frequencies = as.data.frame(as.matrix(DocumentTermMatrix(region_names, control = list(wordLengths = c(2, Inf)))))
    # 
    #     regions <- colnames(region_names_frequencies)
    #     frequencies <- colSums(region_names_frequencies)
    # 
    #     regions_frequencies <- data.frame(regions, frequencies)
    # 
    #     regions_wordcloud <- wordcloud2(regions_frequencies, backgroundColor = "#353c42", minRotation = -pi/2, maxRotation = -pi/2, size = 3.5)
    # 
    #     regions_wordcloud
    # })
    
    output$points_countries_map <- renderPlotly({
        
        data <- dataset()
        
        # Display average number of points for each country
        
        points_by_country_data = data %>%
            group_by(country) %>% 
            summarise(n = n(), avg_points = mean(points))  
        
        # US should be replaced with USA
        points_by_country_data$country <- recode(points_by_country_data$country, !!!list('US' = 'USA'))
        
        worldmap_init = map_data("world")
        
        points_by_country_data <- merge(x = worldmap_init, 
                                        y = points_by_country_data,
                                        by.x = "region",
                                        by.y = "country", 
                                        all.x = TRUE) %>% arrange(desc(order))
        
        points_countries_map <- ggplot(data = points_by_country_data,
                                       aes(x = long, 
                                       y = lat, 
                                       group = group,
                                       color = region)) +
            scale_fill_viridis_c(option = "plasma")+
            theme_minimal()+               
            geom_polygon(aes(fill = avg_points)) +
            labs(fill='Average nr. of points')+
            theme(legend.position = 'none')              
        
        
        ggplotly(points_countries_map)
    })
}

shinyApp(ui, server)
