# Center for Research Informatics
# University of Chicago
# ExScalibur
# reads_per_base_gc.R -- The Per Base GC tab which simply renders a plot

# dat.pbgc -- reactive global dataframe
dat.pbgc <- reactive({ G.reads.gc })

# readGC -- reactive GC data frame
readsGC <- reactive({
  if (input$reads_sample == "all") {
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      fastqc.GCPB.agg <- ddply(dat.pbgc(), .(Type, PGC), summarize,
                               Count=sum(Count))
      return(fastqc.GCPB.agg)
    }
    # GMD Project
    else {
      fastqc.GCPB.agg <- ddply(dat.pbgc(), .(PGC), summarize,
                               Count=sum(Count))
      return(fastqc.GCPB.agg)
    }
  } else {
    fastqc.GCPB.DF <- droplevels(subset(dat.pbgc(), Sample == input$reads_sample))
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      fastqc.GCPB.agg <- ddply(fastqc.GCPB.DF, .(Sample, Type, PGC), summarize,
                               Count=sum(Count))
      return(fastqc.GCPB.agg)
    }
    # GMD Project
    else { 
      fastqc.GCPB.agg <- ddply(fastqc.GCPB.DF, .(Sample, PGC), summarize,
                               Count=sum(Count))
      return(fastqc.GCPB.agg)
    }
  }
})

# downloadHandler() for pbq 
#output$downloadReadData <- downloadHandler(
#  # Returns the string which tells the client browser what name to use when
#  # saving the file.
#  filename = function() {
#    curr_name <- gsub(" ", "_", config$project)
#    paste(curr_name, "tb_reads_pbgc", input$filetype, sep=".")
#  },
#  # Function to write the data to a file given to it by
#  # the argument file
#  content = function(file) {
#    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
#
#    # Write to a file specifived by the 'file' argument
#    write.table(dat.pbgc(), file, sep=sep, row.names=FALSE)
#  }
#)

pbgcPlot <- function(dat) {
  p<-ggplot(dat, aes(x=PGC, y=Count)) +
    geom_bar(stat="identity") +
    ylab("Frequency") +
    xlab("% GC of sequence")
  if(isTRUE(IS_SOMATIC)) print(p + facet_wrap(~Type, 2, 1))
  else print(p)
}

output$pbgcPlot <- renderPlot({
  curr <- input$reads_sample
  readsGC()
  isolate(pbgcPlot(dat=readsGC()))
})

output$reads_pbgc_tab <- renderUI({ rgcpUI() })

rgcpUI <- reactive({
  list(
    h4("Sequence GC Percentage", 
       HTML(paste('<span class="label label-info">', input$reads_sample, "</span>", sep = ""))),
    plotOutput("pbgcPlot"),
    p("Distribution of percentage of GC for each sequence (+/- 1 sd).")
  )
})
