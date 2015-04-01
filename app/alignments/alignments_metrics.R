# Center for Research Informatics
# University of Chicago
# ExScalibur
# alignments_metrics.R -- Alignment Metrics tab view

dat.asm <- reactive({ G.alignment.summary })

alignMetrics <- reactive({
  if (input$align_sample == "all") {
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      return(ddply(dat.asm(), .(Type, Aln, Category, Measure), summarize,
                           Mean = mean(Value, na.rm=TRUE),
                           SD = sd(Value, na.rm=TRUE)))
    }
    # GMD Project
    else { 
      return(ddply(dat.asm(), .(Aln, Category, Measure), summarize,
                           Mean = mean(Value, na.rm=TRUE),
                           SD = sd(Value, na.rm=TRUE)))
    }
  }
  else {
    # SMD Project
    metrics.sub <- droplevels(subset(dat.asm(), Sample == input$align_sample))
    if(isTRUE(IS_SOMATIC)){
      return(ddply(metrics.sub, .(Type, Aln, Category, Measure), summarize,
                           Mean = mean(Value, na.rm=TRUE),
                           SD = sd(Value, na.rm=TRUE)))
    }
    # GMD Project
    else { 
      return(ddply(metrics.sub, .(Aln, Category, Measure), summarize,
                           Mean = mean(Value, na.rm=TRUE),
                           SD = sd(Value, na.rm=TRUE)))
    }
  }
})

alignMetricsPlot <- function(dat, measure, dropUnpaired=FALSE) {
  dat.metric <- subset(dat, Measure == measure)
  if (dropUnpaired) dat.metric <- subset(dat.metric, dat.metric$Category != "Unpaired")
  dodge <- position_dodge(width=0.9)
  p<-ggplot(dat.metric, aes(x=Category, y=Mean, fill=Aln)) +
    geom_bar(stat="identity", position=dodge) +
    geom_errorbar(aes(ymin=Mean - SD, ymax = Mean + SD), stat="identity", position=dodge, width=0.25) +
    scale_fill_brewer(palette="Set1") +
    ylab(NULL) + xlab(NULL) +
    theme(legend.position = "top")
  if(isTRUE(IS_SOMATIC)) print(p+facet_wrap(~Type, 2, 1))
  else print(p) 
}

# downloadHandler() for pbq 
output$downloadAlnData <- downloadHandler(
  # Returns the string which tells the client browser what name to use when
  # saving the file.
  filename = function() {
    curr_name <- gsub(" ", "_", config$project)
    paste(curr_name, "tb_align_metrics", input$filetype, sep=".")
  },
  # Function to write the data to a file given to it by
  # the argument file
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")

    # Write to a file specifived by the 'file' argument
    write.table(dat.asm(), file, sep=sep, row.names=FALSE)
  }
)

output$align_metrics_tab <- renderUI({ alignMetricsUI() })

alignMetricsUI <- reactive({
  list(
    fluidRow(
        column(6, wellPanel(
          h4("Total Reads", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="TOTAL_READS")
          }))
        ),
        column(6, wellPanel(
          h4("Mean Read Length", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="MEAN_READ_LENGTH")
          }))
        )
    ),

    fluidRow(
        column(6, wellPanel(
          h4("Mismatch Rate", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="PF_MISMATCH_RATE")
          }))
        ),
        column(6, wellPanel(
          h4("Error Rate", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="TOTAL_READS")
          }))
        )
    ),
      
    fluidRow(
        column(6, wellPanel(
          h4("InDel Rate", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="PF_INDEL_RATE")
          }))
        ),
        column(6, wellPanel(
          h4("Strand Balance", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="STRAND_BALANCE")
          }))
        )
    ),

    fluidRow(
        column(6, wellPanel(
          h4("% Chimeras", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="PCT_CHIMERAS", dropUnpaired=TRUE)
          }))
        ),
        column(6, wellPanel(
          h4("% Aligned Pairs", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep=''))),
          renderPlot({
            alignMetrics()
            alignMetricsPlot(dat=alignMetrics(), measure="PCT_READS_ALIGNED_IN_PAIRS", dropUnpaired=TRUE)
          }))
        )
    )
  )
})
