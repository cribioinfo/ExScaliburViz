library(shinythemes)
shinyUI(navbarPage(theme = shinytheme("spacelab"), title = paste(config$project, reporter.type), id="nav_smd", inverse=FALSE,
  tabPanel("Reads", uiOutput("reads_ui")),
  tabPanel("Alignments", uiOutput("alignments_ui")),
  tabPanel("Variants", uiOutput("variant_ui")),
  tabPanel("Downloads", uiOutput("downloads_ui"))
))
