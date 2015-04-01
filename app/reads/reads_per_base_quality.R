# Center for Research Informatics
# University of Chicago
# ExScalibur
# reads_per_base_qualities.R -- The Per Base Quality tab which simply renders a plot

# dat.pbq -- reactive global dataframe
dat.pbq <- reactive({ G.reads.pbq })

# readPBQ <- reactive data frame used for plotting
readsPBQ <- reactive({
  if (input$reads_sample == "all") {
    # SMD Project
    if(isTRUE(IS_SOMATIC)){
      fastqc.PBQ.agg <- ddply(dat.pbq(), .(Type, Base), summarize,
                              Median=mean(Median),
                              Mean=mean(Mean),
                              P10=mean(P10),
                              P90=mean(P90),
                              LQ=min(LQ),
                              UQ=max(UQ))
      return(fastqc.PBQ.agg)
    }
    # GMD Project
    else {
      fastqc.PBQ.agg <- ddply(dat.pbq(), .(Base), summarize,
                              Median=mean(Median),
                              Mean=mean(Mean),
                              P10=mean(P10),
                              P90=mean(P90),
                              LQ=min(LQ),
                              UQ=max(UQ))
      return(fastqc.PBQ.agg)
    }
  } else {
    fastqc.PBQ.DF <- droplevels(subset(dat.pbq(), Sample == input$reads_sample))
    if(isTRUE(IS_SOMATIC)){
      fastqc.PBQ.agg <- ddply(fastqc.PBQ.DF, .(Sample, Type, Base), summarize,
                              Median=mean(Median),
                              Mean=mean(Mean),
                              P10=mean(P10),
                              P90=mean(P90),
                              LQ=min(LQ),
                              UQ=max(UQ))
      return(fastqc.PBQ.agg)
    }
    # GMD Project
    else {
      fastqc.PBQ.agg <- ddply(fastqc.PBQ.DF, .(Sample, Base), summarize,
                              Median=mean(Median),
                              Mean=mean(Mean),
                              P10=mean(P10),
                              P90=mean(P90),
                              LQ=min(LQ),
                              UQ=max(UQ))
      return(fastqc.PBQ.agg)
    }
  }
})

# pbqPlot -- Plotting function
pbqPlot <- function(dat) {
  p<-ggplot(dat, aes(x=Base, y = Median)) + 
    geom_ribbon(data=dat, aes(x=Base, ymin=P10, ymax=P90), 
               fill="lightblue", alpha=.40) +
    scale_alpha(name="10% & 90% Quartiles") +
    geom_point(aes(color="Median")) +
    geom_point(data=dat, aes(x=Base, y=Mean, color="Mean")) +
    scale_colour_manual(name="Metric", labels=c("Mean", "Median"), 
                       values=c("black", "red")) +
    xlab("Base Position") +
    ylab("Phred-scaled Quality")
  if(isTRUE(IS_SOMATIC)) print(p+facet_wrap(~Type, 2, 1))
  else print(p)
}

# downloadHandler() for pbq 
#output$downloadReadData <- downloadHandler(
#  # Returns the string which tells the client browser what name to use when
#  # saving the file.
#  filename = function() {
#    curr_name <- gsub(" ", "_", config$project)
#    paste(curr_name, "tb_reads_pbq", input$filetype, sep=".")
#  },
#  # Function to write the data to a file given to it by
#  # the argument file
#  content = function(file) {
#    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
#
#    # Write to a file specifived by the 'file' argument
#    write.table(dat.pbq(), file, sep=sep, row.names=FALSE)
#  }
#)

# output$pbqPlot -- Render of plot
output$pbqPlot <- renderPlot({
  input$reads_sample
  readsPBQ()  
  pbqPlot(dat=readsPBQ())
})

# output$reads_pqb_tab -- Quality Per Base tab
output$reads_pbq_tab <- renderUI({ rpbqUI() })

rpbqUI <- reactive({
  list(
    h4("Quality Plots", HTML(paste('<span class="label label-info">', input$reads_sample, "</span>", sep = ""))),
    plotOutput("pbqPlot"),  
    p("Quality scores summarized by average mean quality (black) and average median quality (red).",
      "The light blue area represents the mean 10-th and 90-th percentiles.")
  )
})
