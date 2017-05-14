# source: http://spatial.ly/2015/03/mapping-flows/
# load packages 

library(plyr)
library(ggplot2)
library(maptools)

# download the 2 files and move them into you R directory (mine is ~/R/)
# https://www.nomisweb.co.uk/articles/882.aspx
# http://ingrid.geog.ucl.ac.uk/~james/msoa_popweightedcentroids.csv

# load the data and select only 3 columns

input<-read.table("R/wu03ew_v1.csv", sep=",", header=T)
input<- input[,1:3]
names(input)<- c("origin", "destination","total")

# tranforming post code into coordinates

centroids<- read.csv("R/msoa_popweightedcentroids.csv")
or.xy<- merge(input, centroids, by.x="origin", by.y="Code")
names(or.xy)<- c("origin", "destination", "trips", "o_name", "oX", "oY")
dest.xy<-  merge(or.xy, centroids, by.x="destination", by.y="Code")
names(dest.xy)<- c("origin", "destination", "trips", "o_name", "oX", "oY","d_name", "dX", "dY")

# removes the axes in the resulting plot

xquiet<- scale_x_continuous("", breaks=NULL)
yquiet<-scale_y_continuous("", breaks=NULL)
quiet<-list(xquiet, yquiet)

# plotting the map - takes LONG LONG time

ggplot(dest.xy[which(dest.xy$trips>10),], aes(oX, oY))+
  #The next line tells ggplot that we wish to plot line segments. The "alpha=" is line transparency and used below 
  geom_segment(aes(x=oX, y=oY,xend=dX, yend=dY, alpha=trips), col="white")+
  #Here is the magic bit that sets line transparency - essential to make the plot readable
  scale_alpha_continuous(range = c(0.03, 0.3))+
  #Set black background, ditch axes and fix aspect ratio
  theme(panel.background = element_rect(fill='black',colour='black'))+quiet+coord_equal()
