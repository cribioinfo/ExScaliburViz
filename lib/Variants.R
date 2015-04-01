# Center for Research Informatics
# University of Chicago
# ExScalibur
# Variants -- functions for loading Somatic/Germline variants

###############################
## Somatic TSV
.loadSomatic <- function(item) {
  read.delim(file.path(reporter.dir, item$somatic$inputs$somatic_table), header = TRUE, sep = "\t",
        stringsAsFactors=FALSE)
}

.smd.table.ori <- function() {
  tsv.list <- lapply(config$data, .loadSomatic)
  tsv.DF <- do.call(rbind, tsv.list)
  tsv.sb <- subset(tsv.DF, tsv.DF$Func.refGene == "exonic")
  tsv.sb$ExonicFunc.refGene <- gsub("\\sSNV", "", tsv.sb$ExonicFunc.refGene)
  return(tsv.sb)
}

.smd.table <- function() {
  tsv.list <- lapply(config$data, .loadSomatic)
  tsv.DF <- do.call(rbind, tsv.list)
  tsv.sb <- subset(tsv.DF, tsv.DF$Func.refGene == "exonic")
  cos <- gsub("(ID=)(COSM.+);OCCURENCE(.+)", "\\2", tsv.sb$cosmic70)
  tsv.sb$cosmic70 <- sapply(cos, USE.NAMES=FALSE, function(x) {
    if(!is.na(x)) {
      curr <- unlist(strsplit(x, ","))
      val <- sapply(curr, function(y) {
        paste("<a href=http://cancer.sanger.ac.uk/cosmic/search?q=",
              y," target=_blank>", y, "</a>", sep="")
      })
      return(paste(val, collapse=","))
      #return(val)
    } else {
      return(x)
    }
  })
  tsv.sb$snp138 <- sapply(tsv.sb$snp138, USE.NAMES=FALSE, function(x) {
    if(!is.na(x)) {
      curr <- unlist(strsplit(x, ","))
      val <- sapply(curr, function(y) {
        paste("<a href=http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?searchType=adhoc_search&type=rs&rs=",
              y, " target=_blank>", y, "</a>", sep="")
      })
      return(paste(val, collapse=","))
    } else {
      return(x)
    }
  })
  tsv.sb$ExonicFunc.refGene <- gsub("\\sSNV", "", tsv.sb$ExonicFunc.refGene)
  return(tsv.sb)
}

###############################
## Output variant table
.variant.table.ori <- function() {
  if(isTRUE(IS_SOMATIC)) .smd.table.ori()
  else .gmd.table.ori()
}

###############################
## Germline TSV 
.loadGermline <- function(item) {
  read.delim(file.path(reporter.dir, item$variants$inputs$variant_table), header = TRUE, sep = "\t", 
	stringsAsFactors=FALSE)
}

.gmd.table.ori <- function() {
  tsv.list <- lapply(config$data, .loadGermline)
  tsv.DF <- do.call(rbind, tsv.list)
  tsv.sb <- subset(tsv.DF, tsv.DF$Func == "exonic")
  tsv.sb$ExonicFunc <- gsub("\\sSNV", "", tsv.sb$ExonicFunc)
  return(tsv.sb)
}

.gmd.table <- function() {
  tsv.list <- lapply(config$data, .loadGermline)
  tsv.DF <- do.call(rbind, tsv.list)
  tsv.sb <- subset(tsv.DF, tsv.DF$Func == "exonic")
  cos <- gsub("(ID=)(COSM.+);OCCURENCE(.+)", "\\2", tsv.sb$COSMIC)
  tsv.sb$COSMIC <- sapply(cos, USE.NAMES=FALSE, function(x) {
    if(!is.na(x)) {
      curr <- unlist(strsplit(x, ","))
      val <- sapply(curr, function(y) {
        paste("<a href=http://cancer.sanger.ac.uk/cosmic/search?q=",
              y," target=_blank>", y, "</a>", sep="")
      })
      return(paste(val, collapse=","))
      #return(val)
    } else {
      return(x)
    }
  })
  tsv.sb$dbSNP <- sapply(tsv.sb$dbSNP, USE.NAMES=FALSE, function(x) {
    if(!is.na(x)) {
      curr <- unlist(strsplit(x, ","))
      val <- sapply(curr, function(y) {
        paste("<a href=http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?searchType=adhoc_search&type=rs&rs=",
              y, " target=_blank>", y, "</a>", sep="")
      })
      return(paste(val, collapse=","))
      #return(val)
    } else {
      return(x)
    }
  })
  tsv.sb$ExonicFunc <- gsub("\\sSNV", "", tsv.sb$ExonicFunc)
  return(tsv.sb)
}

.variant.table <- function() {
  if(isTRUE(IS_SOMATIC)) return(.smd.table())
  else return(.gmd.table())
}
