# Center for Research Informatics
# University of Chicago
# ExScaliburSMD
# alignment_ui.R -- Shiny views for Picard Metrics and Coverage results

source("app/alignments/alignments_metrics.R", local=TRUE)
source("app/alignments/alignments_insert_metrics.R", local=TRUE)
source("app/alignments/alignments_insert_hist.R", local=TRUE)
source("app/alignments/alignments_total_coverage.R", local=TRUE)

# The base view for Alignments results
output$alignments_ui <- renderUI({
  list(
    sidebarLayout(
      sidebarPanel(
        wellPanel(
          selectInput("align_sample",
            label = "Choose all samples or one sample.",
            choices = c(c("all"), sampleList), 
            selected = "all"
          )
        ),
        br(),
        p("Various tables and plots based on the alignment summary statistics:"),
        tags$ul(
          tags$li(tags$b("Alignment Metrics"), "- Several alignment QC graphs"),
          tags$li(tags$b("Insert Size Metrics"), "- Tabular view of insert size metrics"),
          tags$li(tags$b("Insert Size Histogram"), "- Plot insert size distributions"),
          tags$li(tags$b("Total Coverage"), "- Plot of the total exome coverage")
        ),
        br(),
        h6(em("ExScaliburViz v1.0.0"), br(),
           em("Center for Research Informatics"),
           br(), em("University of Chicago")
        )
      ),
      
      mainPanel(id = "aligntabs",
        uiOutput("alignments_data")
      )
    )
  )
})

## Tabview
output$alignments_data <- renderUI({ alignmentsUI() })

alignmentsUI <- reactive({
  list(
    tabsetPanel(id = "aligntabs",
      tabPanel("Alignment Metrics", value="tb_align_metrics", uiOutput("align_metrics_tab")),
    
      tabPanel("Insert Size Metrics", value="tb_align_insert_metrics", uiOutput("align_insert_metrics_tab")),
    
      tabPanel("Insert Size Histogram", value="tb_align_insert_hist", uiOutput("align_insert_size_tab")),
      
      tabPanel("Total Coverage", value="tb_align_total_cov", uiOutput("align_total_coverage_tab"))
    )
  )
})

## Observers
#curr <- ""
#observe({
#  if (!is.null(input$aligntabs)) {
#    if (input$align_sample != curr) {
#      updateTabsetPanel(session, inputId="aligntabs", selected=input$aligntabs)
#      curr <- input$align_sample
#    }
#  }
#})
