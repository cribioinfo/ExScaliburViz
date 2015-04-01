# Center for Research Informatics
# University of Chicago
# ExScalibur
# downloads_ui.R -- Download files 

# The base view for variant results
output$downloads_ui <- renderUI({
  list(
    fluidPage(
      mainPanel(id = "downloadtabs",
        uiOutput("downloads_data")
      )
    )
  )
})

# Download Handlers
# READS BASIC
output$dlReadsBasic <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "reads_basic", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.reads.basic, file, sep=sep, row.names=FALSE)
  }
)
# READS PBQ 
output$dlReadsPBQ <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "reads_pbq", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.reads.pbq, file, sep=sep, row.names=FALSE)
  }
)
# READS GC 
output$dlReadsPBGC <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "reads_gc", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.reads.gc, file, sep=sep, row.names=FALSE)
  }
)
# READS NC
output$dlReadsPBNC <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "reads_pbnc", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.reads.nc, file, sep=sep, row.names=FALSE)
  }
)

# ALIGNMENTS METRICS 
output$dlAlnMetrics <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "alignment_metrics", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.alignment.summary, file, sep=sep, row.names=FALSE)
  }
)
# ALIGNMENTS ISIZE METRICS 
output$dlAlnInsertMetrics <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "alignment_insert_metrics", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.alignment.isize.metrics, file, sep=sep, row.names=FALSE)
  }
)
# ALIGNMENTS ISIZE HIST 
output$dlAlnInsertHist <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "alignment_insert_hist", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.alignment.isize.hist, file, sep=sep, row.names=FALSE)
  }
)
# ALIGNMENTS COVERAGE 
output$dlAlnTotalCoverage <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "alignment_total_coverage", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(G.alignment.total.coverage, file, sep=sep, row.names=FALSE)
  }
)

# VARIANTS 
output$dlVariants <- downloadHandler(
  filename = function() {
    pshort <- gsub(" ", "_", config$project)
    paste(pshort, "variants", input$filetype, sep=".")
  },
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
    write.table(.variant.table.ori(), file, sep=sep, row.names=FALSE)
  }
)

# Tabview
output$downloads_data <- renderUI({ downloadUI() })

downloadUI <- reactive({
  list(
    fluidRow(h3("Download ExScaliburViz Datasets."),
             p("Click the links below to download a CSV or TSV file for the given dataset.")),
    fluidRow(radioButtons("filetype", "File type:", choices=c("csv", "tsv"), inline=TRUE)),
    fluidRow(
      column(4, wellPanel(
        h5("Reads Datasets"),
        tags$ul(
          tags$li(downloadLink("dlReadsBasic", 'Basic Overview')),
          tags$li(downloadLink("dlReadsPBQ", 'Per Base Quality')),
          tags$li(downloadLink("dlReadsPBGC", 'Per Sequence GC %')),
          tags$li(downloadLink("dlReadsPBNC", 'Per Base N Counts')))
      )),
      column(4, wellPanel(
        h5("Alignment Datasets"),
        tags$ul(
          tags$li(downloadLink("dlAlnMetrics", 'Alignment Metrics')),
          tags$li(downloadLink("dlAlnInsertMetrics", 'Insert Size Metrics')),
          tags$li(downloadLink("dlAlnInsertHist", 'Insert Size Histogram')),
          tags$li(downloadLink("dlAlnTotalCoverage", 'Total Coverage')))
      )),
      column(4, wellPanel(
        h5("Variant Datasets"),
        tags$ul(
          tags$li(downloadLink("dlVariants", 'Variant Table')))
      ))
    )
  )
})
