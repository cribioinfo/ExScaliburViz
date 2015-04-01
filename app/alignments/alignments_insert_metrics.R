# Center for Research Informatics
# University of Chicago
# ExScalibur
# alignments_insert_metrics.R -- Alignment Insert Size Metrics tab view

dat.ism <- reactive({ G.alignment.isize.metrics })

## Insert Size Metrics
isMetrics <- reactive({
  keepA <- c("MEAN_INSERT_SIZE", "MAX_INSERT_SIZE", "MIN_INSERT_SIZE", "WIDTH_OF_10_PERCENT", 
            "WIDTH_OF_90_PERCENT", "STANDARD_DEVIATION")
  dat.A <- droplevels(subset(dat.ism(), Measure %in% keepA))

  if (input$align_sample == "all") {
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      return(ddply(dat.A, .(Type, Aln, Measure), summarize,
                  Mean=mean(Value, na.rm=TRUE),
                  SD=sd(Value, na.rm=TRUE)))
    } 
    # GMD Project
    else {
      return(ddply(dat.A, .(Aln, Measure), summarize,
                  Mean=mean(Value, na.rm=TRUE),
                  SD=sd(Value, na.rm=TRUE)))
    }
  }
  else {
    curr.samp.df<-droplevels(subset(dat.A, Sample == input$align_sample))
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      keepB <- c("Type", "Aln", "Measure", "Value")
      return(curr.samp.df[keepB])
    }
    # GMD Project
    else {
      keepB <- c("Aln", "Measure", "Value")
      return(curr.samp.df[keepB])
    }
  }
})

output$align_insert_metrics_tab <- renderUI({ isMetricsUI() })

isMetricsUI <- reactive({
  list(  
    h4("Overview Table", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep = ''))),
    renderDataTable({
      isMetrics()
    }, options = list(orderClasses=TRUE, bCaseInsensitive=TRUE, lengthMenu=c(5, 10, 20), pageLength = 18))
  )
})
