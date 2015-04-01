# Center for Research Informatics
# University of Chicago
# ExScalibur
# reads_per_base_nc.R -- The Per Base NC tab which simply renders a plot

dat.ncpb <- reactive({ G.reads.nc })

readsNC <- reactive({
  if (input$reads_sample == "all") {
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      fastqc.NCPB.agg <- ddply(dat.ncpb(), .(Type, Base), summarize,
                               Mean=mean(Count),
                               SD=sd(Count))
      return(fastqc.NCPB.agg)
    }
    # GMD Project
    else {
      fastqc.NCPB.agg <- ddply(dat.ncpb(), .(Base), summarize,
                               Mean=mean(Count),
                               SD=sd(Count))
      return(fastqc.NCPB.agg)
    }
  } else {
    fastqc.NCPB.DF <- droplevels(subset(dat.ncpb(), Sample == input$reads_sample))
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      fastqc.NCPB.agg <- ddply(fastqc.NCPB.DF, .(Sample, Type, Base), summarize,
                               Mean=mean(Count), SD=sd(Count))
      return(fastqc.NCPB.agg)
    }
    # GMD Project
    else { 
      fastqc.NCPB.agg <- ddply(fastqc.NCPB.DF, .(Sample, Base), summarize,
                               Mean=mean(Count), SD=sd(Count))
      return(fastqc.NCPB.agg)
    }
  }
})

ncpbPlot <- function(dat) {
  p<-ggplot(dat, aes(x=Base, y=Mean)) +
         geom_point() +
         geom_errorbar(aes(ymin=Mean - SD, ymax=Mean + SD))
  if(isTRUE(IS_SOMATIC)) print(p + facet_wrap(~Type, 2, 1))
  else print(p)
}

output$ncpbPlot <- renderPlot({
  readsNC()
  isolate( ncpbPlot(dat=readsNC()) )
})

# downloadHandler() for pbq 
#output$downloadReadData <- downloadHandler(
#  # Returns the string which tells the client browser what name to use when
#  # saving the file.
#  filename = function() {
#    curr_name <- gsub(" ", "_", config$project)
#    paste(curr_name, "tb_reads_pbnc", input$filetype, sep=".")
#  },
#  # Function to write the data to a file given to it by
#  # the argument file
#  content = function(file) {
#    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
#
#    # Write to a file specifived by the 'file' argument
#    write.table(dat.ncpb(), file, sep=sep, row.names=FALSE)
#  }
#)



output$reads_pbnc_tab <- renderUI({ rncpbUI() })

rncpbUI <- reactive({
  list(
    h4("N Counts", HTML(paste('<span class="label label-info">', input$reads_sample, "</span>", sep = ""))),
    plotOutput("ncpbPlot"),
    p("Mean count of N's at each position (+/- 1 sd).")
  )
})
