NDVIvalidate <- function(NDVI,year){ ##function to find dates witch are available at all locations.
  NDVI1 <- names(NDVI[1])
  NDVI1u<- unlist(NDVI[1])
  NDVI1l<- length(NDVI1u)
  NDVIa <- names(NDVI)
  NDVIal<- length(NDVIa)
  NDVIy <- paste(NDVI1,as.character(year),sep = '.')
  dates <- c()
  for(i in 1:NDVI1l){
    NDVIi <- unlist(strsplit(names(NDVI1u[i]),'-'))[1]
    if (NDVIi == NDVIy){
      date <- unlist(strsplit(names(NDVI1u[i]),'[.]'))[2]
      # dates <- c(dates,date)
      valid <- TRUE
      for(j in 2:NDVIal){
        checkStr <- paste(NDVIa[j],date,sep=".")
        if (valid && !(checkStr %in% names(unlist(NDVI[j])))){
          valid <- FALSE
        }
      }
      if (valid){
        dates <- c(dates,date)
      }
    }
  }
  return(dates)
}