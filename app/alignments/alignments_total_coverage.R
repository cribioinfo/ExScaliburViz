# Center for Research Informatics
# University of Chicago
# ExScaliburSMD
# alignments_total_coverage.R -- Alignment total coverage view 

dat.tcov <- reactive({ G.alignment.total.coverage })

tcov.DF <- reactive({
  if(input$align_sample == "all"){
    if(isTRUE(IS_SOMATIC)){
      return(ddply(dat.tcov(), .(Type, Aln), summarize, 
                   Mean=mean(Coverage, na.rm=TRUE), SD=sd(Coverage, na.rm=TRUE)))
    } else {
      return(ddply(dat.tcov(), .(Aln), summarize, 
             Mean=mean(Coverage, na.rm=TRUE), SD=sd(Coverage, na.rm=TRUE)))
    }
  } else {
    tcov.sub <- droplevels(subset(dat.tcov(), Sample == input$align_sample))
    if(isTRUE(IS_SOMATIC)) return(ddply(tcov.sub, .(Type, Aln), summarize,
                                  Mean=mean(Coverage, na.rm=TRUE),
                                  SD=sd(Coverage, na.rm=TRUE)))
    else return(ddply(tcov.sub, .(Aln), summarize,
                                  Mean=mean(Coverage, na.rm=TRUE),
                                  SD=sd(Coverage, na.rm=TRUE)))
  }
})

tCovPlot <- function(dat) {
  dodge <- position_dodge(width=0.9)
  if(isTRUE(IS_SOMATIC)) {
    ggplot(dat, aes(x=Type, y=Mean, fill=Aln)) +
      geom_bar(stat="identity", position=dodge) +
      geom_errorbar(aes(ymin=Mean - SD, ymax = Mean + SD), stat="identity", position=dodge, width=0.25) +
      scale_fill_brewer(palette="Set1") +
      ylab(NULL) + xlab(NULL) +
      theme(legend.position = "top")
  } else {
    ggplot(dat, aes(x=Aln, y=Mean, fill=Aln)) +
      geom_bar(stat="identity", position=dodge, width=0.25) +
      geom_errorbar(aes(ymin=Mean - SD, ymax = Mean + SD), stat="identity", position=dodge, width=0.10) +
      scale_fill_brewer(palette="Set1") +
      ylab(NULL) + xlab(NULL) +
      theme(legend.position = "top")
  }
}

output$tCovPlot <- renderPlot({
  tcov.DF()  
  tCovPlot(dat=tcov.DF())
})

output$align_total_coverage_tab <- renderUI({ alignTotalCovUI() })

alignTotalCovUI <- reactive({
  list(
    h4("Total Coverage", HTML(paste('<span class="label label-info">', input$align_sample, "</span>", sep = ''))),
    plotOutput("tCovPlot")
  )
})
