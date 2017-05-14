# source: http://spatialanalysis.co.uk/2012/06/mapping-worlds-biggest-airlines/

# Get the would boudariea and flight database
# http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m-urban-area.zip
# https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat

# Load libraries
library(ggplot2)
library(maps)
library(rgeos)
library(maptools)
gpclibPermit()

#Load in your great circles (see above for link on how to do this). You need a file that has long, lat, airline and group. The group variable is produced as part of the Anthrospace tutorial.
gcircles

#Get a world map
worldmap

#Load in your urban areas shapefile from Natural Earth Data
urbanareasin

#Simplify these using the gsimplify function from the rgeos package
simp

#Fortify them for use with ggplot2
urbanareas<-fortify(simp)

#This step removes the axes labels etc when called in the plot.
xquiet yquiet<-scale_y_continuous("", breaks=NA, lim=c(70,-70))
quiet<-list(xquiet, yquiet)

#Create a base plot
base

#Then build up the layers
wrld<-c(geom_polygon(aes(long,lat,group=group), size = 0.1, colour= "#090D2A", fill="#090D2A", alpha=1, data=worldmap))
urb

#Bring it all together with the great circles
base+wrld+urb+geom_path(data=gcircles, aes(long,lat, group=group, colour=airline),alpha=0.1, lineend="round",lwd=0.1)+coord_equal()+quiet+opts(panel.background = theme_rect(fill='#00001C',colour='#00001C'))
