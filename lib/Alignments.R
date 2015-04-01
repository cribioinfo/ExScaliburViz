# Center for Research Informatics
# University of Chicago
# ExScaliburViz
# Alignments -- functions for dealing with the summarzed Alignment Metrics files.

# Loads the alignment summary metrics file
.loadAlignmentSummaryMetrics <- function(item) {
  read.delim(file.path(reporter.dir, item$alignments$inputs$alignment_summary_metrics), header = TRUE, 
             sep = "\t", stringsAsFactors=FALSE)
}

# Wrapper for loading the alignment summary metrics file
.alignment.summary <- function() {
  metrics.list <- lapply(config$data, .loadAlignmentSummaryMetrics)
  metrics.DF   <- do.call(rbind, metrics.list)
}

# Loads the insert size metrics file
.loadInsertSizeMetrics <- function(item) {
  read.delim(file.path(reporter.dir, item$alignments$inputs$insert_size_metrics), header = TRUE, 
		sep = "\t", stringsAsFactors=FALSE)
}

# Wrapper for loading the insert size metrics file 
.insert_size_metrics <- function() {
  metrics.list  <- lapply(config$data, .loadInsertSizeMetrics)
  metrics.DF    <- do.call(rbind, metrics.list)
  metrics.table <- subset(metrics.DF, metrics.DF$Category=="TABLE" & metrics.DF$Measure !="PAIR_ORIENTATION")
  metrics.table <- within(metrics.table, {Value <- as.numeric(Value)})
}

# Loads the insert size histogram file
.insert_size_hist <- function(){
  metrics.list  <- lapply(config$data, .loadInsertSizeMetrics)
  metrics.DF    <- do.call(rbind, metrics.list)
  metrics.table <- subset(metrics.DF, metrics.DF$Category=="HIST")
  metrics.table <- within(metrics.table, {
    Value   <- as.integer(Value)
    Measure <- as.integer(Measure)
  })
}

# Loads the total coverage file 
.loadTotalCoverage <- function(item) {
  read.delim(file.path(reporter.dir, item$alignments$inputs$total_coverage), header = TRUE, sep = "\t", 
  	stringsAsFactors=FALSE)
}

# Wrapper for loading the total coverage file
.total_coverage <- function() {
  coverage.list <- lapply(config$data, .loadTotalCoverage)
  coverage.DF   <- do.call(rbind, coverage.list)
}
