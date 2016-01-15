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

# define CRS object for RD projection

prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")


# Load data ---------------------------------------------------------------

untar("Data/BRP_Subset_ZOGron.geojson.tar.gz",exdir="Data")
parcels = readOGR("Data/BRP_Subset_ZOGron.geojson", "OGRGeoJSON") ## loaded, around 140 MB
adm <- raster::getData("GADM", country = "NLD",level = 2, path = "Data") ## Municipalities of the Netherlands


# Prepare administrative areas --------------------------------------------

boundary <- adm[adm$NAME_2 == "Stadskanaal",]
rm(adm)
boundary <- spTransform(boundary,CRS(proj4string(parcels))) ## Transform to RDnew (EPSG:28992)


# Extract fields partially inside boundary ---------------------------------

parcelsOfInterest <- polygonSelection(boundary,parcels,TRUE,TRUE)
head(parcelsOfInterest@data$CENTROID@coords)


# plot selection method difference  ---------------------------------------

plot(polygonSelection(boundary,parcels,F,F),border='red') ## parcels at least partially inside boundary
plot(polygonSelection(boundary,parcels,T,F),add=T) ## parcels largely inside boundary
