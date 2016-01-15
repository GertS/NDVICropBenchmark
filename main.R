## main.R
## author: Gert Sterenborg 
## email: gertsterenborg@gmail.com
## 15 Jan 2016


# Dependencies ------------------------------------------------------------

library(rgdal)


# Load parcels ------------------------------------------------------------


parcels = readOGR("Data/BRP_Subset_ZOGron.geojson", "OGRGeoJSON") ## around 140 MB

