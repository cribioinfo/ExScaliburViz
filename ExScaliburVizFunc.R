# Kyle Hernandez
# Center for Research Informatics
# ExScaliburViz
if(!suppressMessages(require(yaml, warn.conflicts=F))) {
  stop('Missing required package yaml!! Please install: install.packages("yaml")')
}
if(!suppressMessages(require(shiny, warn.conflicts=F))) {
  stop('Missing required package shiny!! Please install: install.packages("shiny")')
}
if(!suppressMessages(require(ggplot2, warn.conflicts=F))) {
  stop('Missing required package ggplot2!! Please install: install.packages("ggplot2")')
}
if(!suppressMessages(require(reshape2, warn.conflicts=F))) {
  stop('Missing required package reshape2!! Please install: install.packages("reshape2")')
}
if(!suppressMessages(require(plyr, warn.conflicts=F))) {
  stop('Missing required package plyr!! Please install: install.packages("plyr")')
}
if(!suppressMessages(require(tools, warn.conflicts=F))) {
  stop('Missing required package tools!! Please install: install.packages("tools")')
}

## Local sources
source('lib/Logger.R', local=TRUE)
source('lib/FastQC.R', local=TRUE)
source('lib/Alignments.R', local=TRUE)
source('lib/Variants.R', local=TRUE)

## ExScaliburViz
ExScaliburViz <- function(configFile, reporter.type=c("SMD", "GMD")){
  reporter.type <<- reporter.type
  if(!file.exists(configFile)) stop(paste("Missing ", configFile, ". Please check your path and filename"))
  config <<- yaml.load_file(configFile)
  reporter.dir <<- dirname(configFile)
  IS_SOMATIC <<- ifelse(reporter.type=="SMD", TRUE, FALSE)
  sampleList <<- sapply(config$data, function(x) x$sample)

  print("Loading Read QC...")
  G.reads.basic <<- reads.basic()
  G.reads.pbq <<- reads.PBQ()
  G.reads.gc <<- reads.GCPB()
  G.reads.nc <<- reads.NCPB()

  print("Loading Alignment QC...")
  G.alignment.summary        <<- .alignment.summary()
  G.alignment.isize.metrics  <<- .insert_size_metrics()
  G.alignment.isize.hist     <<- .insert_size_hist()
  G.alignment.total.coverage <<- .total_coverage()

  # Variant dataset
  print("Loading Variant Data...")
  G.variant.table            <<- .variant.table()

  print("Launching App")
  shiny::runApp()
}

# Basic
reads.basic <- function() {
  if(isTRUE(IS_SOMATIC)) fastqc.list <- lapply(config$data, loadFastqcBasic.smd)
  else fastqc.list <- lapply(config$data, loadFastqcBasic.gmd)
  do.call(rbind, fastqc.list)
}

# Per-base qualities
reads.PBQ<-function(){
  if(isTRUE(IS_SOMATIC)) fastqc.PBQ.list<-lapply(config$data,loadFastqcPBQ.smd)
  else fastqc.PBQ.list<-lapply(config$data,loadFastqcPBQ.gmd)
  do.call(rbind, fastqc.PBQ.list)
}

# GC richness
reads.GCPB<-function(){
  if(isTRUE(IS_SOMATIC)) fastqc.GCPB.list<-lapply(config$data,loadFastqcGC.smd)
  else fastqc.GCPB.list<-lapply(config$data,loadFastqcGC.gmd)
  do.call(rbind, fastqc.GCPB.list)
}

# N's frequency
reads.NCPB<-function(){
  if(isTRUE(IS_SOMATIC)) fastqc.NCPB.list<-lapply(config$data,loadFastqcNC.smd)
  else fastqc.NCPB.list<-lapply(config$data,loadFastqcNC.gmd)
  do.call(rbind, fastqc.NCPB.list)
}
