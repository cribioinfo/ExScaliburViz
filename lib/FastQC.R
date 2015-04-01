#' \code{loadFastqcBasic.smd} loads and parses the FastQC basic files from the YAML config 
#'
#' @param item an item in the list of samples from the yaml object 
#' @return a data.frame containing Illumina sequence summary statistics
loadFastqcBasic.smd<-function(item){
  normal.files <- lapply(item$fastqc$inputs$normal, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq, "fastqc_data.txt"), header=FALSE, stringsAsFactors=FALSE)$V2[1:10]
    x$paired <- as.logical(x$paired)
    if(isTRUE(x$paired)) {
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_data.txt"),header=FALSE,stringsAsFactors=FALSE)$V2[1:10]
      return(data.frame(sample=item$sample, Type="NORMAL", readgroup=x$readgroup, encoding=xl[6], 
                 read_length=as.numeric(xl[9]),
                 leftfile=xl[4], left_basic=xl[2],total_left=as.numeric(xl[7]),
                 filtered_left=as.numeric(xl[8]), pct_GC_left=as.numeric(xl[10]),
                 rightfile=xr[4], right_basic=xr[2], total_right=as.numeric(xr[7]),
                 filtered_right=as.numeric(xr[8]), pct_GC_right=as.numeric(xr[10])
            ))
    }
    else {
      return(data.frame(sample=item$sample, Type="NORMAL", readgroup=x$readgroup, encoding=xl[6], 
                 read_length=as.numeric(xl[9]),
                 leftfile=xl[4], left_basic=xl[2],total_left=as.numeric(xl[7]),
                 filtered_left=as.numeric(xl[8]), pct_GC_left=as.numeric(xl[10]),
                 rightfile=NA, right_basic=NA, total_right=NA,
                 filtered_right=NA, pct_GC_right=NA
            ))
    }
  })
  normal.df<-do.call(rbind,normal.files)
  tumor.files <- lapply(item$fastqc$inputs$tumor, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq, "fastqc_data.txt"), header=FALSE, stringsAsFactors=FALSE)$V2[1:10]
    if(x$paired) {
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_data.txt"),header=FALSE,stringsAsFactors=FALSE)$V2[1:10]
      return(data.frame(sample=item$sample, Type="TUMOR", readgroup=x$readgroup, encoding=xl[6], 
                 read_length=as.numeric(xl[9]),
                 leftfile=xl[4], left_basic=xl[2],total_left=as.numeric(xl[7]),
                 filtered_left=as.numeric(xl[8]), pct_GC_left=as.numeric(xl[10]),
                 rightfile=xr[4], right_basic=xr[2], total_right=as.numeric(xr[7]),
                 filtered_right=as.numeric(xr[8]), pct_GC_right=as.numeric(xr[10])
            ))
    }
    else {
      return(data.frame(sample=item$sample, Type="TUMOR", readgroup=x$readgroup, encoding=xl[6], 
                 read_length=as.numeric(xl[9]),
                 leftfile=xl[4], left_basic=xl[2],total_left=as.numeric(xl[7]),
                 filtered_left=as.numeric(xl[8]), pct_GC_left=as.numeric(xl[10]),
                 rightfile=NA, right_basic=NA, total_right=NA,
                 filtered_right=NA, pct_GC_right=NA
            ))
    }
  })
  tumor.df<-do.call(rbind,tumor.files)
  rbind(normal.df,tumor.df)
}

#' \code{loadFastqcBasic.gmd} loads and parses the FastQC basic files from the YAML config 
#'
#' @param item an item in the list of samples from the yaml object 
#' @return a data.frame containing Illumina sequence summary statistics
loadFastqcBasic.gmd<-function(item){
  input.files <- lapply(item$fastqc$inputs, function(x) {
    x$paired <- as.logical(x$paired)
    xl<-read.delim(file.path(reporter.dir,x$leftseq, "fastqc_data.txt"), header=FALSE, stringsAsFactors=FALSE)$V2[1:10]
    if(isTRUE(x$paired)) {
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_data.txt"),header=FALSE,stringsAsFactors=FALSE)$V2[1:10]
      return(data.frame(sample=item$sample, readgroup=x$readgroup, encoding=xl[6], read_length=as.numeric(xl[9]),
                 leftfile=xl[4], left_basic=xl[2],total_left=as.numeric(xl[7]),
                 filtered_left=as.numeric(xl[8]), pct_GC_left=as.numeric(xl[10]),
                 rightfile=xr[4], right_basic=xr[2], total_right=as.numeric(xr[7]),
                 filtered_right=as.numeric(xr[8]), pct_GC_right=as.numeric(xr[10])
            ))
    }
    else {
      return(data.frame(sample=item$sample, readgroup=x$readgroup, encoding=xl[6], read_length=as.numeric(xl[9]),
                 leftfile=xl[4], left_basic=xl[2],total_left=as.numeric(xl[7]),
                 filtered_left=as.numeric(xl[8]), pct_GC_left=as.numeric(xl[10]),
                 rightfile=NA, right_basic=NA, total_right=NA,
                 filtered_right=NA, pct_GC_right=NA
            ))
    }
  })
  input.df<-do.call(rbind,input.files)
  return(input.df) 
}

#' \code{loadFastqcPBQ.smd} parses out per-base quality score metrics from the yaml config file
#' for ExScaliburSMD projects.
#' 
#'  @param item the object from the yaml file
#'  @return a data.frame of per-base quality statistics
loadFastqcPBQ.smd <- function(item){
  normal.files<-lapply(item$fastqc$inputs$normal, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_qbd.txt"),header=TRUE)
    xl$Sample <- item$sample
    xl$Type   <- "NORMAL"
    xl$Readgroup <- x$readgroup
    xl$Pair   <- "R1"
    if(x$paired){
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_qbd.txt"),header=TRUE)
      xr$Sample <- item$sample
      xr$Type   <- "NORMAL"
      xr$Readgroup <- x$readgroup
      xr$Pair   <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  normal.df<-do.call(rbind,normal.files)
  tumor.files<-lapply(item$fastqc$inputs$tumor, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_qbd.txt"),header=TRUE)
    xl$Sample <- item$sample
    xl$Type   <- "TUMOR"
    xl$Readgroup <- x$readgroup
    xl$Pair   <- "R1"
    if(x$paired){
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_qbd.txt"),header=TRUE)
      xr$Sample <- item$sample
      xr$Type   <- "TUMOR"
      xr$Readgroup <- x$readgroup
      xr$Pair   <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  tumor.df<-do.call(rbind,tumor.files)
  rbind(normal.df, tumor.df)
}

#' \code{loadFastqcPBQ.gmd} parses out per-base quality score metrics from the yaml config file
#' for ExScaliburGMD projects.
#' 
#'  @param item the object from the yaml file
#'  @return a data.frame of per-base quality statistics
loadFastqcPBQ.gmd <- function(item){
  input.files<-lapply(item$fastqc$inputs, function(x) {
    xl           <-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_qbd.txt"),header=TRUE)
    xl$Sample    <- item$sample
    xl$Readgroup <- x$readgroup
    xl$Pair      <- "R1"
    x$paired     <- as.logical(x$paired)
    if(isTRUE(x$paired)){
      xr           <-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_qbd.txt"),header=TRUE)
      xr$Sample    <- item$sample
      xr$Readgroup <- x$readgroup
      xr$Pair      <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  input.df<-do.call(rbind,input.files)
  return(input.df)
}

#' \code{loadFastqcGC.smd} parses out per-sequence GC richness.
#' 
#' @param list item the object from the yaml file
#' @return a data.frame of per-sequence GC richness
loadFastqcGC.smd <- function(item) {
  normal.files<-lapply(item$fastqc$inputs$normal, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_gcbd.txt"),header=TRUE)
    xl$Sample <- item$sample
    xl$Type   <- "NORMAL"
    xl$Readgroup <- x$readgroup
    xl$Pair   <- "R1"
    if(x$paired){
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_gcbd.txt"),header=TRUE)
      xr$Sample <- item$sample
      xr$Type   <- "NORMAL"
      xr$Readgroup <- x$readgroup
      xr$Pair   <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  normal.df<-do.call(rbind,normal.files)
  tumor.files<-lapply(item$fastqc$inputs$tumor, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_gcbd.txt"),header=TRUE)
    xl$Sample <- item$sample
    xl$Type   <- "TUMOR"
    xl$Readgroup <- x$readgroup
    xl$Pair   <- "R1"
    if(x$paired){
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_gcbd.txt"),header=TRUE)
      xr$Sample <- item$sample
      xr$Type   <- "TUMOR"
      xr$Readgroup <- x$readgroup
      xr$Pair   <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  tumor.df<-do.call(rbind,tumor.files)
  rbind(normal.df, tumor.df)
}

#' \code{loadFastqcGC.gmd} parses out per-sequence GC richness.
#' 
#' @param list item the object from the yaml file
#' @return a data.frame of per-sequence GC richness
loadFastqcGC.gmd <- function(item) {
  input.files<-lapply(item$fastqc$inputs, function(x) {
    xl           <-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_gcbd.txt"),header=TRUE)
    xl$Sample    <- item$sample
    xl$Readgroup <- x$readgroup
    xl$Pair      <- "R1"
    x$paired     <- as.logical(x$paired)
    if(x$paired){
      xr           <-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_gcbd.txt"),header=TRUE)
      xr$Sample    <- item$sample
      xr$Readgroup <- x$readgroup
      xr$Pair      <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  input.df<-do.call(rbind,input.files)
  return(input.df)
}

#' \code{loadFastqcNC.smd} parses out per-base N counts.
#' 
#' @param list item the object from the yaml file
#' @return a data.frame of per-base N counts
loadFastqcNC.smd <- function(item) {
  normal.files<-lapply(item$fastqc$inputs$normal, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_pbnc.txt"),header=TRUE)
    xl$Sample <- item$sample
    xl$Type   <- "NORMAL"
    xl$Readgroup <- x$readgroup
    xl$Pair   <- "R1"
    if(x$paired){
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_pbnc.txt"),header=TRUE)
      xr$Sample <- item$sample
      xr$Type   <- "NORMAL"
      xr$Readgroup <- x$readgroup
      xr$Pair   <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  normal.df<-do.call(rbind,normal.files)
  tumor.files<-lapply(item$fastqc$inputs$tumor, function(x) {
    xl<-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_pbnc.txt"),header=TRUE)
    xl$Sample <- item$sample
    xl$Type   <- "TUMOR"
    xl$Readgroup <- x$readgroup
    xl$Pair   <- "R1"
    if(x$paired){
      xr<-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_pbnc.txt"),header=TRUE)
      xr$Sample <- item$sample
      xr$Type   <- "TUMOR"
      xr$Readgroup <- x$readgroup
      xr$Pair   <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  tumor.df<-do.call(rbind,tumor.files)
  rbind(normal.df, tumor.df)
}

#' \code{loadFastqcNC.gmd} parses out per-base N counts.
#' 
#' @param list item the object from the yaml file
#' @return a data.frame of per-base N counts
loadFastqcNC.gmd <- function(item) {
  input.files<-lapply(item$fastqc$inputs, function(x) {
    xl           <-read.delim(file.path(reporter.dir,x$leftseq,"fastqc_pbnc.txt"),header=TRUE)
    xl$Sample    <- item$sample
    xl$Readgroup <- x$readgroup
    xl$Pair      <- "R1"
    x$paired     <- as.logical(x$paired)
    if(x$paired){
      xr           <-read.delim(file.path(reporter.dir,x$rightseq,"fastqc_pbnc.txt"),header=TRUE)
      xr$Sample    <- item$sample
      xr$Readgroup <- x$readgroup
      xr$Pair      <- "R2"
      return(rbind(xl,xr))
    }
    else {
      return(xl)
    }
  })
  input.df<-do.call(rbind,input.files)
  return(input.df)
}
