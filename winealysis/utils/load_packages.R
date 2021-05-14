pkg <- c("readr",
         "dplyr",
         "ggplot2",
         "kableExtra",
         "highcharter",
         "plotly",
         "viridisLite",
         "cowplot",
         "treemap",
         "tm",
         "wordcloud",
         "wordcloud2",
         "RColorBrewer",
         "maps",
         "httr",
         "jsonlite")

lapply(pkg, require, character.only = TRUE)