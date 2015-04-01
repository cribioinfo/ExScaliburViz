# Kyle Hernandez
# Center for Research Informatics
# University of Chicago
# Logger.R -- Implementation of a basic logger

logger.info <- function(msg) {
  message(paste('[CRI] [INFO] [',Sys.time(),'] - ', msg, sep = ""))
}

logger.error <- function(msg) {
  stop(paste('[CRI] [ERROR] [',Sys.time(),'] - ', msg, sep = ""))
}
