# Center for Research Informatics
# University of Chicago
# ExScalibur
# fastqc_ui.R -- Shiny views for FastQC results

# Source local files
source("app/reads/reads_basic.R", local=TRUE)
source("app/reads/reads_per_base_quality.R", local=TRUE)
source("app/reads/reads_per_base_gc.R", local=TRUE)
source("app/reads/reads_per_base_nc.R", local=TRUE)

# The base view for FastQC results
# This is a side panel with a tab panel
output$reads_ui <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        wellPanel(
          selectInput("reads_sample",
                      label = "Choose all samples or one sample.",
                      choices = c(c("all"), sampleList),
                      selected = "all"
          )
        ),

        br(),
        p("Various tables and plots based on the output of FastQC:"),
        tags$ul(
          tags$li(tags$b("Basic Overview"), "- Tabular summary of sequence data quality"),
          tags$li(tags$b("Per Base Qualities"), "- Plot of quality at each base position"),
          tags$li(tags$b("Per Sequence % GC"), "- Plot of GC percentage distribution across all sequences"),
          tags$li(tags$b("Per Base N Count"), "- Plot of the counts of N's at each base position")
        ),
        br(),
        h6(em("ExScaliburViz v1.0.0"), br(),
           em("Center for Research Informatics"),
           br(), em("University of Chicago")
        )
      ),
      mainPanel(id = "readtabs",
                uiOutput("reads_data")
      )
    )
  )
})

######################################
# React to the user inputs for samples
output$reads_data <- renderUI({ readsUI() })

readsUI <- reactive({
  list(tabsetPanel(id = "readtabs",
                   
                   tabPanel("Basic", value="tb_reads_basic", uiOutput("reads_basic_tab")),
                   
                   tabPanel("Per Base Qualities", value="tb_reads_pbq", uiOutput("reads_pbq_tab")),
                   
                   tabPanel("Per Sequence % GC", value="tb_reads_pbgc", uiOutput("reads_pbgc_tab")),
                   
                   tabPanel("Per Base N Count", value="tb_reads_pbnc", uiOutput("reads_pbnc_tab"))
  )
  )
})

#curr.reads <- NULL
#observe({
#  print(curr.reads)
#  if (!is.null(input$readtabs) && !is.null(input$curr.reads)) {
#    if(input$reads_sample != curr.reads) {
#      updateTabsetPanel(session, inputId="readtabs", selected=input$readtabs)
#      curr.reads <- input$reads_sample
#      println(curr.reads)
#    }
#  }
#})
