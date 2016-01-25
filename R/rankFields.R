## rankFields.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 25 Jan 2016

## A function to rank crops by there individual NDVI value
## results in a value between 0 and 1 for every field
## 1 is the best score, 0 the worst.

rankFields <- function(cropTable,NDVItable){
  cropTypes <- unique(cropTable)
  cropTypesl<- length(cropTypes)
  NDVItablel<- ncol(NDVItable)
  rankMatrix <- matrix(,nrow = length(cropTable),ncol = ncol(NDVItable))
  for (i in 1:cropTypesl){
    for (j in 1:NDVItablel){
      if (sum(cropTable == cropTypes[i])==1){
        tempNDVItable <- NDVItable[cropTable == cropTypes[i],][j]
        fieldIndex <- which(cropTable == cropTypes[i])
        rankMatrix[fieldIndex,j] <- 1
      }else{
        tempNDVItable <- NDVItable[cropTable == cropTypes[i],][,j]
        fieldIndex <- as.integer(unlist(strsplit(names(tempNDVItable),"V"))[c(FALSE,TRUE)])
        tempRank <- rank(unname(unlist(tempNDVItable)),ties.method="first")/length(tempNDVItable)
        rankMatrix[fieldIndex,j] <- tempRank
      }
    }
  }
  return(rankMatrix)
}