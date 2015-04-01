# Center for Research Informatics
# University of Chicago
# ExScalibur-SMD
# reads_basic.R -- All functions related to the "Basic" tab view of the reads_ui

# dat.rb -- Global DF Reactive 
dat.rb <- reactive({ G.reads.basic })

# readsBasic -- The basic dataframe dependent on 'all' samples or one 
readsBasic <- reactive({
  if (input$reads_sample == "all") {
    # SMD Project
    if (isTRUE(IS_SOMATIC)){
      return(ddply(dat.rb(), .(Type), summarize,
                 "N"=length(left_basic) + length(right_basic),
                 "Total R1"=sum(total_left),
                 "Total R2"=sum(total_right),
                 "Avg. Length"=mean(read_length, na.rm=TRUE),
                 "Avg. GC %"=(mean(pct_GC_left, na.rm=TRUE) + mean(pct_GC_right, na.rm=TRUE)) / N,
                 "% PASS"=100 * (length(which(left_basic == "pass")) + 
                                   length(which(right_basic == "pass"))) / N))
    } 
    # GMD Project
    else {
      curr_tot = length(dat.rb()$left_basic) + length(dat.rb()$right_basic)
      return(data.frame("N"=curr_tot,
                 "Total R1"=sum(dat.rb()$total_left),
                 "Total R2"=sum(dat.rb()$total_right),
                 "Avg. Length"=mean(dat.rb()$read_length, na.rm=TRUE),
                 "Avg. GC %"=(mean(dat.rb()$pct_GC_left, na.rm=TRUE) + mean(dat.rb()$pct_GC_right, na.rm=TRUE)) / curr_tot,
                 "% PASS"=100 * (length(which(dat.rb()$left_basic == "pass")) + 
                                   length(which(dat.rb()$right_basic == "pass"))) / curr_tot))
    }
  } 

  # Subset by sample
  else {
    sampDF <- droplevels(subset(dat.rb(), sample == input$reads_sample))
    # SMD Project
    if (isTRUE(IS_SOMATIC)){
      keep <- c("Type", "readgroup", "encoding", "read_length", "left_basic", "total_left", "pct_GC_left",
              "right_basic", "total_right", "pct_GC_right")
      keepDF <- sampDF[keep]
      names(keepDF) <- c("Type", "Readgroup", "Encoding", "Length", "R1 Basic", "R1 Total", "R1 %GC", 
                       "R2 Basic", "R2 Total", "R2 %GC")
      return(keepDF)
    }
    # GMD Project
    else {
      keep <- c("readgroup", "encoding", "read_length", "left_basic", "total_left", "pct_GC_left",
                "right_basic", "total_right", "pct_GC_right")
      keepDF <- sampDF[keep]
      names(keepDF) <- c("Readgroup", "Encoding", "Length", "R1 Basic", "R1 Total", "R1 %GC", 
                         "R2 Basic", "R2 Total", "R2 %GC")
      return(keepDF)
    }
  }
})

# downloadHandler() for basic fastq
output$downloadReadData <- downloadHandler(
  # Returns the string which tells the client browser what name to use when
  # saving the file.
  filename = function() {
    curr_name <- gsub(" ", "_", config$project)
    paste(curr_name, "tb_reads_basic", input$filetype, sep=".")
  },
  # Function to write the data to a file given to it by
  # the argument file
  content = function(file) {
    sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")

    # Write to a file specifived by the 'file' argument
    write.table(dat.rb(), file, sep=sep, row.names=FALSE)
  }
)

# output$data_table -- The reactive DataTable object for displaying to the user
output$data_table <- renderDataTable({
  readsBasic()
}, options = list(orderClasses=TRUE, bCaseInsensitive=TRUE, lengthMenu=c(5, 10, 20), pageLength = 18))

output$dt_full <- renderTable({
  readsBasic()
}) 

# output$reads_basic_tab -- the UI for the Reads tab 
output$reads_basic_tab <- renderUI({ rbasicUI() })

# rbasicUI -- The reactive UI
rbasicUI <- reactive({
  list(h4("Summary Table", HTML(paste('<span class="label label-info">', input$reads_sample, "</span>", sep = ""))),
  if (input$reads_sample=="all") tableOutput("dt_full") else dataTableOutput("data_table")
  )
})
