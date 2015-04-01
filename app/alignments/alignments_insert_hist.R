# Center for Research Informatics
# University of Chicago
# ExScalibur
# alignments_insert_hist.R -- Alignment Insert Size Histogram tab view

dat.isize <- reactive({ G.alignment.isize.hist })

iSizeHist <- reactive({
  if(input$align_sample == "all"){
    if(isTRUE(IS_SOMATIC)) return(ddply(dat.isize(), .(Type, Aln, Measure), summarize, Value=sum(Value, na.rm=TRUE)))
    else return(ddply(dat.isize(), .(Aln, Measure), summarize, Value=sum(Value, na.rm=TRUE)))
  } else {
    return(droplevels(subset(dat.isize(), Sample == input$align_sample)))
  }
})

isizeHistPlot <- function(dat) {
  p<-ggplot(dat, aes(y=Value, x=Measure)) +
    geom_bar(stat="identity", position="identity", width=1, alpha=0.4) +
    ylab("Counts") +
    xlab("Insert Size")
  if(isTRUE(IS_SOMATIC)) print(p+facet_grid(Aln~Type))
  else print(p+facet_wrap(~Aln, ncol=1))
}

output$isizeHistPlot <- renderPlot({
  iSizeHist()
  isizeHistPlot(dat=iSizeHist())
})

output$align_insert_size_tab <- renderUI({ alignHistUI() })

alignHistUI <- reactive({
  list(
    h4("Insert Size Histrogram", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep = ''))),
    plotOutput("isizeHistPlot")
  )
})
