## fetchNDVI.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 15 Jan 2016

coordSample <- c(266051.7, 559000.5)
names(coordSample) <- c('x','y')
fetchNDVI <- function (coords=coordSample){
  return(c(coords[[1]],coords[[2]]))
}
