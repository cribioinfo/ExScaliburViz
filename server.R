shinyServer(function(input, output, session) {
  source("app/reads/reads_ui.R", local=TRUE)
  source("app/alignments/alignments_ui.R", local=TRUE)
  source("app/variants/variant_ui.R", local=TRUE)
  source("app/downloads/downloads_ui.R", local=TRUE)
})
