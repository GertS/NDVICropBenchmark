## polygonSelection.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 15 Jan 2016

library(rgeos)

polygonSelection <- function(boundary,polygons,is.centroidInside=T,returnCentroids=T){

  # Extract polygons that are (partially) inside the boundary ---------------
  
  intersects <- gIntersects(boundary,polygons,byid = TRUE) ## polygons that are (partially) inside the boundary
  selectedPolygons <- polygons[which(intersects),] ## select these polygons
  
  # Extract fields largely inside boundary -----------------------------------
  
  if(is.centroidInside){
    polygonCentroids <- gCentroid(selectedPolygons,byid=TRUE) ## Centroid of every polygon
    intersects <- gIntersects(boundary,polygonCentroids,byid=TRUE) ## Centroid inside boundary
    selectedPolygons <- selectedPolygons[which(intersects),] ## polygons which centroid is inside the boundary
  }
  
  # generate centroids ------------------------------------------------------
  
  if(returnCentroids){
    polygonCentroids <- gCentroid(selectedPolygons,byid=TRUE) ## Centroid of every polygon
    selectedPolygons@data$CENTROID <- polygonCentroids ## add centroids to dataframe
  }
  return(selectedPolygons)
}

