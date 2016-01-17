## main.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 15 Jan 2016


# Dependencies and global parameters --------------------------------------

rm(list = ls())
library(sp)
library(rgdal)
library(rgeos)
source('R/polygonSelection.R')
source('R/fetchNDVI.R')

# Load data ---------------------------------------------------------------

untar("Data/BRP_Subset_ZOGron.geojson.tar.gz",exdir="Data")
parcels = readOGR("Data/BRP_Subset_ZOGron.geojson", "OGRGeoJSON") ## loaded, around 140 MB
adm <- raster::getData("GADM", country = "NLD",level = 2, path = "Data") ## Municipalities of the Netherlands


# Prepare administrative areas --------------------------------------------

adm_name <- c("Stadskanaal")
boundary <- adm[adm$NAME_2 %in% adm_name,]
rm(adm)
boundary <- spTransform(boundary,CRS(proj4string(parcels))) ## Transform to RDnew (EPSG:28992)


# Extract fields that are largely inside boundary --------------------------

parcelsOfInterest <- polygonSelection(boundary,parcels,TRUE,TRUE)
head(parcelsOfInterest@data$CENTROID@coords)


# plot selection method difference  INTERMEZZO ----------------------------

plot(polygonSelection(boundary,parcels,F,F),border='red',lwd=0.5) ## parcels at least partially inside boundary
plot(polygonSelection(boundary,parcels,T,F),add=T,lwd=0.5) ## parcels largely inside boundary
plot(boundary,add=T,border="green") ## boundary
title(paste("Municipality of",adm_name),xlab="longitude", ylab="latitude")
legend("bottomleft", title="Legend",
       c("centroids outside boundary","centroids inside boundary","boundary"), 
       lty=c(1,1,1),lwd=c(2.5,2.5,2.5),col=c("red","brown","green"),horiz = F,
       cex = 0.75)

# Fetch NDVI values -------------------------------------------------------

fetchNDVI()
# parcelsOfInterest@data$NDVI <- mapply(c(parcelsOfInterest@data$CENTROID@coords[,'x'],parcelsOfInterest@data$CENTROID@coords[,'y']),fetchNDVI)
# parcelsOfInterest@data$NDVI <- mapply(fetchNDVI,parcelsOfInterest@data$CENTROID@coords[,1],parcelsOfInterest@data$CENTROID@coords[,2])
# parcelsOfInterest@data$NDVI <- tapply(parcelsOfInterest@data$CENTROID@coords[,1],parcelsOfInterest@data$CENTROID@coords[,2],fetchNDVI)

lengte <- length(parcelsOfInterest)
a <- list()
for(i in 1:lengte){
  append(a,list(fetchNDVI(parcelsOfInterest@data$CENTROID@coords[i,])))
}
