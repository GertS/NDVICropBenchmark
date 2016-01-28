## main.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 15 Jan 2016


# Dependencies and global parameters --------------------------------------

rm(list = ls())
library(sp)
library(rgdal)
library(rgeos)
library(data.table)
library(plyr)
source('R/polygonSelection.R')
source('R/fetchNDVI.R')
source('R/NDVIvalidate.R')
source('R/rankFields.R')

# Load data ---------------------------------------------------------------

untar("Data/BRP_Subset_ZOGron.geojson.tar.gz",exdir="Data")
parcels = readOGR("Data/BRP_Subset_ZOGron.geojson", "OGRGeoJSON") ## when loaded around 140 MB
adm <- raster::getData("GADM", country = "NLD",level = 2, path = "Data") ## Municipalities of the Netherlands


# Prepare administrative areas --------------------------------------------

adm_name <- c("Stadskanaal") ## change the municipality name to what area you want to check. (NOT the complete BRP-dataset is downloaded, only South-East Groningen)
boundary <- adm[adm$NAME_2 %in% adm_name,]
rm(adm)

boundary <- gUnaryUnion(boundary) ## multi polygons to one boundary polygon
boundary <- spTransform(boundary,CRS(proj4string(parcels))) ## Transform to RDnew (EPSG:28992)

# Extract fields that are largely inside boundary --------------------------

parcelsOfInterest <- polygonSelection(boundary,parcels,is.centroidInside = TRUE,returnCentroids = FALSE)


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
# parcelsOfInterest <- parcelsOfInterest[1:20,]

if (!file.exists(NDVIFileName)){ ##Fetch only when not already loaded, to prevent high server load and long waiting time
  NDVI <- mapply(fetchNDVI, parcelsOfInterest@data$CENTROID@coords[,'x'], parcelsOfInterest@data$CENTROID@coords[,'y'])
  save(NDVI,file = NDVIFileName)
}else{
  load(file = NDVIFileName)
}

# all NDVI dates which are available on all parcels
NDVI <- NDVIvalidate(NDVI,2015)

NDVItable <- as.data.table(NDVI)
NDVItable <- t(NDVItable)
dates <- names(NDVI[[1]])
# parcelsOfInterest$NDVI <- unname(NDVI)

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

#store it as json to be used in the webpage:
sink(paste('./webpageData/boundaryStatistics',adm_name,'.json',sep = ''))
cat(toJSON(as.data.frame(t(fieldStatisticsHA)),collapse = ''))
sink()

# NDVI statistics ---------------------------------------------------------
cropTable <- parcelsOfInterest$GWS_GEWAS
fieldRanks <- rankFields(cropTable,NDVItable)
colnames(fieldRanks) <- dates
colnames(NDVItable)  <- dates
rownames(fieldRanks) <- c(1:nrow(fieldRanks))
rownames(NDVItable)  <- c(1:nrow(NDVItable))

#store the ranks as a json to be used in the webpage:
sink(paste('./webpageData/ranks',adm_name,'.json',sep = ''))
cat(toJSON(as.data.frame(fieldRanks)))
sink()
#store the NDVI as a json to be used in the webpage:
sink(paste('./webpageData/ndvi',adm_name,'.json',sep = ''))
cat(toJSON(as.data.frame(NDVItable)))
sink()

# export Spatial data frame ------------------------------------------------

parcelsOfInterest$id <- c(1:nrow(fieldRanks))
# toGeoJSON(parcelsOfInterest,paste('./webpageData/parcels',adm_name,sep = ""))
exportFileName        <- paste('./webpageData/parcels',adm_name,sep = "")
exportFileNameGeoJson <- paste(exportFileName,".GeoJSON",sep = "")
exportFileNameWGS84   <- paste(exportFileName,"WGS84.GeoJSON",sep="")
files <- c(exportFileName,exportFileNameGeoJson,exportFileNameWGS84)

#Remove file before creating one
for (i in 1:3){
  if (file.exists(files[i])){ 
    system(paste("rm",files[i]))
  }
}
  
#write File
writeOGR(parcelsOfInterest,exportFileName,layer="parcels",driver = "GeoJSON")
#add CRS EPSG:28992 (RDnew)
command <- paste("ogr2ogr -f GeoJSON  -s_srs EPSG:28992 -t_srs EPSG:28992 ",exportFileName,".GeoJSON"," ",exportFileName,sep="")
system(command)
#generate WGS84 file
command <- paste("ogr2ogr -f GeoJSON  -s_srs EPSG:28992 -t_srs EPSG:4326 ",exportFileName,"WGS84.GeoJSON"," ",exportFileName,".GeoJSON",sep="")
system(command)
