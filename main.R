## main.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 15 Jan 2016


# Dependencies and global parameters --------------------------------------

rm(list = ls())
library(sp)
library(rgdal)
library(rgeos)
library(RJSONIO)
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
boundary <- gUnaryUnion(boundary) ## multi polygons to one boundary polygon
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

NDVIFileName <- paste('Data/ndvi',paste(adm_name,collapse=''),'.RData',sep = '')

# for testing use a subset:
# parcelsOfInterest <- parcelsOfInterest[1:10,]

if (!file.exists(NDVIFileName)){ ##Fetch only when not already loaded, to prevent high server load and long waiting time
  NDVI <- mapply(fetchNDVI, parcelsOfInterest@data$CENTROID@coords[,'x'], parcelsOfInterest@data$CENTROID@coords[,'y'])
  save(NDVI,file = NDVIFileName)
}else{
  load(file = NDVIFileName)
}

parcelsOfInterest@data$NDVI <- NDVI


# Interesting area statistics ---------------------------------------------

# top crop types:
fieldStatisticsHA <- aggregate(parcelsOfInterest@data$GEOMETRIE_Area, by=list(CropType=parcelsOfInterest@data$GWS_GEWAS), FUN=sum)
fieldStatisticsHA <-fieldStatisticsHA[order(-fieldStatisticsHA$x),]

#print top crop types:
top5 <- head(fieldStatisticsHA[1],n=5)
top5[2] <- head(fieldStatisticsHA[2]/10000,n=5)
names(top5) <- c('croptype','Hectares')
paste('The top 5 crops in',adm_name,'are:')
top5

#store it as json to webpage:
sink(paste('./webpageData/boundaryStatistics',adm_name,'.json',sep = ''))
cat(toJSON(as.data.frame(t(fieldStatisticsHA)),collapse = ''))
sink()
