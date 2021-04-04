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
         "RColorBrewer")

lapply(pkg, require, character.only = TRUE)