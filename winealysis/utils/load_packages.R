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
         "maps")

lapply(pkg, require, character.only = TRUE)