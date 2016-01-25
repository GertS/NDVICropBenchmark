## NDVIvalidate.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 24 Jan 2016

##function to find dates witch are available at all locations and delete all other dates.

NDVIvalidate <- function(NDVI,year){ 
  NDVIout <- unname(NDVI)  #resulting NDVI list
  NDVI1 <- names(NDVI[1])  #id of                  first parcel
  NDVI1u<- unlist(NDVI[1]) #NDVI values of         first parcel
  NDVI1l<- length(NDVI1u)  #total number of values first parcel
  NDVIa <- names(NDVI)     #id's of                  all parcels
  NDVIal<- length(NDVIa)   #total number of          all parcels
  NDVIy <- paste(NDVI1,as.character(year),sep = '.') # id plus correct year
  dates <- c()
  for(i in 1:NDVI1l){      #for every date in parcel 1
    NDVIi <- unlist(strsplit(names(NDVI1u[i]),'-'))[1]
    if (NDVIi == NDVIy){   #if it is the right year
      date <- unlist(strsplit(names(NDVI1u[i]),'[.]'))[2] 
      valid <- TRUE
      for(j in 2:NDVIal){  #for every parcel except the first one
        checkStr <- paste(NDVIa[j],date,sep=".")
        if (valid && !(checkStr %in% names(unlist(NDVI[j])))){ #if the date is not in this parcel
          valid <- FALSE
        }
      }
      if (valid){
        dates <- c(dates,date)
      }
    }
  }
  NDVIout <- popInvalidDates(NDVI,dates)
  return(NDVIout)
}

popInvalidDates <- function(NDVI,dates){
  t1 <- unname(NDVI[1:3])
  t1l<- length(t1)
  t2 <- c()
  for (i in 1:t1l){
    t2[i] <- list(t1[[i]][names(t1[[i]]) %in% dates])
    t2[[i]]<- t2[[i]][sort.list(names(t2[[i]]))]
  }
  return(t2)
}
