# Center for Research Informatics
# University of Chicago
# ExScalibur
# variant_ui.R -- Shiny views for Variant Summary Table 

# The base view for variant results
output$variant_ui <- renderUI({
  list(
    fluidPage(
      mainPanel(id = "varianttabs",
        uiOutput("variant_data")
      )
    )
  )
})

## Tabview
output$variant_data <- renderUI({ variantUI() })

output$var_tb <- renderDataTable({
  if(isTRUE(IS_SOMATIC)) {
    keep <- c("Chr","Start","Ref","Alt","Func.refGene","Gene.refGene","ExonicFunc.refGene",
            "snp138","esp6500si_all","ALL.sites.2014_10","cosmic70", "clinvar_20140929", "CADD_raw",
            "TotalScore")
    curr <- droplevels(subset(G.variant.table, sample==input$variant_sample))
    curr <- curr[names(curr) %in% keep]
    names(curr) <- c("Chr", "Pos", "Ref", "Alt", "Function", "Gene", "Type",
                     "SNP138", "ESP", "1000G", "COSMIC", "ClinVar", "CADD", "Score")
    print(head(curr))
     
    return(curr)
  }

  else {
    keep <- c("Chr","Start","Ref","Alt","Func","Gene","ExonicFunc",
            "dbSNP","ESP6500","Genome1000","COSMIC", "CADD", "ClinVar",
            "TotalScore")

    curr <- droplevels(subset(G.variant.table, Sample==input$variant_sample))
    curr <- curr[names(curr) %in% keep]
    return(curr)
  }
}, escape=c(-8, -11))

variantUI <- reactive({
  list(
    fluidRow(h3("Per-sample variant annotations"), p("We only provide SNV, exonic variants here!!")),
    fluidRow(
      column(4,
             selectInput("variant_sample",
                         label= "Choose a sample.",
                         choices=sampleList,
                         selected=sampleList[0])
      )
    ),
    tags$div(class="row", tags$div(class="span12"), dataTableOutput("var_tb"))
  )
})
