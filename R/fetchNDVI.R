## fetchNDVI.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 15 Jan 2016

library(jsonlite)
library(curl)

domain <- 'https://boerenbunder.nl/chart/'

fetchNDVI <- function (x=266051.7,y=559000.5){
  url <- paste(domain,x,'/',y,sep = '')
  json <- fromJSON(txt=url)
  return(json)
}


#https://boerenbunder.nl/chart/151004.49943949192/464391.12502902746