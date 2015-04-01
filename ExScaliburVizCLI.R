#!/usr/bin/env Rscript
# Kyle Hernandez
# Center for Research Informatics
# University of Chicago
# ExScaliburViz.R -- Main script to generating an ExScalibur report
if(!suppressMessages(require(yaml, warn.conflicts=F))) {
  stop('Missing required package yaml!! Please install: install.packages("yaml")')
}
if(!suppressMessages(require(shiny, warn.conflicts=F))) {
  stop('Missing required package shiny!! Please install: install.packages("shiny")')
}
if(!suppressMessages(require(shinythemes, warn.conflicts=F))) {
  stop('Missing required package shinythemes!! Please install: install.packages("shinythemes")')
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

## Get Local Source
argv     <- commandArgs(F)
base_dir <- normalizePath(dirname(substring(argv[grep("--file=", argv)], 8)))
setwd(base_dir)

## Local sources
source('lib/Logger.R', local=TRUE)
source('lib/FastQC.R', local=TRUE)
source('lib/Alignments.R', local=TRUE)
source('lib/Variants.R', local=TRUE)

################# Command-line Utils
# Parse args
parseArgs <- function(args, requiredArgs) {
  if(length(args) %% 2 == 1 || length(args) == 0) {
    logger.error('Argument missing a value!')
    cmd.help()
  }
  n.i          <- seq(1, length(args), by=2)
  v.i          <- seq(2, length(args), by=2)
  args.name    <- args[n.i]
  args.value   <- args[v.i]
  missing_args <- FALSE
  req.bool     <- requiredArgs %in% args.name
  if(!all(req.bool)){
    logger.error(paste('Missing argument: ', paste(requiredArgs[!req.bool], collapse=","),
                       ".", sep=''))
    missing_args <- TRUE
  }
  res <- args.value
  names(res) <- args.name
  res 
}

cmd.header <- function(){
  logger.info("--------------------------------------------------------------")
  logger.info("ExScaliburViz.R - Dynamic reporting of ExScalibur Projects")
  logger.info("Kyle Hernandez, Center for Research Informatics, University of Chicago")
  logger.info("--------------------------------------------------------------")
}

cmd.help <- function(){
  cat("\nUsage: ExScaliburViz.R --config <config.yml> --type [SMD|GMD]\n")
  cat("\tconfig\tThe FULL path to the configuration YAML file (must be the full path!!)\n")
  cat("\ttype\tEither 'SMD' or 'GMD' depending on the type of ExScalibur pipeline\n")
  stop()
}

cmd.header()
args <- commandArgs(T)
if(length(args)==0){
  cmd.help()
  logger.error('Please provide required command line arguments')
} else if (args[1] == "-h" || args[1] == "--help") {
  cmd.help()
}

################# Main 
parsed_args   <- parseArgs(args, c("--config", "--type")) 
reporter.yaml <- parsed_args["--config"]
reporter.dir  <- dirname(reporter.yaml)
reporter.type <- parsed_args["--type"]
if(!(any(reporter.type %in% c("SMD", "GMD"))))
  logger.error(paste("Reporter Type '", reporter.type, "' unknown! Must be either 'GMD' or 'SMD'", paste=""))
logger.info(paste('Reporter YAML file:', basename(reporter.yaml)))
logger.info(paste('Reporter directory:', reporter.dir))
logger.info(paste('Reporter type:', reporter.type))
 
IS_SOMATIC<-ifelse(reporter.type == "SMD", TRUE, FALSE)
names(IS_SOMATIC) <- NULL

# Check for the existence of the files
if(!file.exists(reporter.yaml)) stop(paste("Missing ",reporter.yaml,". Please check your path and filename.", sep=""))

# Setup all the main datasets
config <- yaml.load_file(reporter.yaml)

# List of all samples
sampleList <- sapply(config$data, function(x) x$sample)

## Reads/FastQC datasets
# Basic information
logger.info("Loading Read QC...")
reads.basic<-function(){
  if(isTRUE(IS_SOMATIC)) fastqc.list<-lapply(config$data,loadFastqcBasic.smd)
  else fastqc.list<-lapply(config$data,loadFastqcBasic.gmd)
  do.call(rbind, fastqc.list)
}
G.reads.basic <- reads.basic()

# Per-base qualities
reads.PBQ<-function(){
  if(isTRUE(IS_SOMATIC)) fastqc.PBQ.list<-lapply(config$data,loadFastqcPBQ.smd)
  else fastqc.PBQ.list<-lapply(config$data,loadFastqcPBQ.gmd)
  do.call(rbind, fastqc.PBQ.list)
}
G.reads.pbq <- reads.PBQ()

# GC richness
reads.GCPB<-function(){
  if(isTRUE(IS_SOMATIC)) fastqc.GCPB.list<-lapply(config$data,loadFastqcGC.smd)
  else fastqc.GCPB.list<-lapply(config$data,loadFastqcGC.gmd)
  do.call(rbind, fastqc.GCPB.list)
}
G.reads.gc <- reads.GCPB()

# N's frequency
reads.NCPB<-function(){
  if(isTRUE(IS_SOMATIC)) fastqc.NCPB.list<-lapply(config$data,loadFastqcNC.smd)
  else fastqc.NCPB.list<-lapply(config$data,loadFastqcNC.gmd)
  do.call(rbind, fastqc.NCPB.list)
}
G.reads.nc <- reads.NCPB()

## Alignments datasets
logger.info("Loading Alignment QC...")
G.alignment.summary        <- .alignment.summary()
G.alignment.isize.metrics  <- .insert_size_metrics()
G.alignment.isize.hist     <- .insert_size_hist()
G.alignment.total.coverage <- .total_coverage()

# Variant dataset
logger.info("Loading Variant Data...")
G.variant.table            <- .variant.table() 

# Run app
logger.info("Launching App...")
shiny::runApp(base_dir, launch.browser = TRUE)
