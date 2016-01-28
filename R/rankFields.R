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
  rankMatrix <- matrix(,nrow = length(cropTable),ncol = ncol(NDVItable)) ## initiate matrix
  for (i in 1:cropTypesl){    ## for every croptype do:
    for (j in 1:NDVItablel){  ## for every date do:
      if (sum(cropTable == cropTypes[i])==1){ ## a catch for crops that occure just once
        tempNDVItable <- NDVItable[cropTable == cropTypes[i],][j]
        fieldIndex <- which(cropTable == cropTypes[i])
        rankMatrix[fieldIndex,j] <- 1
      }else{
        tempNDVItable <- NDVItable[cropTable == cropTypes[i],][,j] ## a table with the relevant ndvi values of the i-th croptype and date j
        fieldIndex <- which(cropTable == cropTypes[i],) ## the indices of the fields with the i-th croptype
        tempRank <- rank(unname(unlist(tempNDVItable)),ties.method="first")/length(tempNDVItable) ## the ranks divided by the total amount of the i-th croptype
        rankMatrix[fieldIndex,j] <- tempRank ## store into the matrix
      }
    }
  }
  return(rankMatrix)
}