# Work done by Alex Spina







require(ggplot2)
require(sp)
require(rgdal)
require(excel.link)
library(ggmap)
library(rgeos)
library(maptools)
library(ggsn)





############################  PARTS THAT NEED TO BE UPDATED #################################################




#####Set the current week for analyses

weekactuelle <- 201702 


#####Reading in datasets######################


######read in data for population estimates
source("C:/Users/Spina/Desktop/Am Timan/R stuff/Census.R")


#######read in case linelist 

linelist <- xl.read.file("C:/Users/Spina/Desktop/Am Timan/HepEdata/Hep E AmTiman_16Jan17_EW01.xlsx", header = TRUE, row.names = NULL, col.names = NULL,
                         xl.sheet = "Master Data Entry Sheet", top.left.cell = "A1", na = ".", password = "MSFHdata",
                         excel.visible = FALSE)
#remove empty rows from bottom of exel sheet
linelist <- linelist[which(!is.na(linelist$`HEV Case ID`)),]
  

########read excel file with waterpoints gps coordinates
waterpoints <- read_excel("C:/Users/Spina/Desktop/Am Timan/Data Old versions/WatSan/GPS Data Entry - WaterPointsUpdated Dec28.xlsm", sheet="Water Points")


########read excel file with chlorination data
chlorination <- read_excel("C:/Users/Spina/Desktop/Am Timan/Data Old versions/WatSan/NEW_2016_Bucket Chlorination Data Tool.xlsx", sheet="WEEKLY SUMMARY")








###########################################################################################################################


              ####                    Automated part begins here




############################################################################################################################











###### Cleaning linelist########################


#######Create Epi-week as numeric to be able to filter dataset 

linelist$week <- as.numeric(paste0(substr(linelist$`EpiWeek FIRST Assessment (Community or Medical)`,0,4),
                        substr(linelist$`EpiWeek FIRST Assessment (Community or Medical)`, 6,7)))


#######Create classification variable (just because name too long in excel) 

linelist$classification <- linelist$`Suspected/Confirmed/Not A Case (based on HEV RDT)`

#######create coordinates for cases in the linelist 
caseptslonglat <- SpatialPoints(cbind(lon = linelist$Longitude[!is.na(linelist$Longitude)&!is.na(linelist$Latitude)],
                                 lat = linelist$Latitude[!is.na(linelist$Longitude)&!is.na(linelist$Latitude)]),
                           proj4string=CRS("+proj=longlat"))
casecoords<-spTransform(caseptslonglat,CRS("+init=epsg:4326"))


#######backup linelist so that have a list with all cases 
linelist2 <- linelist


######merge the coordinates for cases with the linelist dataset (only keeping cases with coordinates)
linelist <- cbind(linelist[!is.na(linelist$Latitude),], casecoords@coords)










#########Merging Shapefiles with population and casecount data############ 


#change the coordinates of cases from the linelist to same referencing system as block shapefile
casecoords <- spTransform(casecoords, CRS = blockpoints@proj4string)


#merge the population data with the blocks shapefile 
blocks <- merge(blocks, output2, by.x= "Name", by.y = "Block", all.x=T)



#count the number of cases with coordinates in each block (total)

count <- over(casecoords, blocks)
count2 <- as.data.frame(table(count$Name))
  
names(count2) <- c("Var1","Total")
  
  
  ####Merge the blocks shapefile with casecount and block population data
  
  blocks <-  merge(blocks, count2, by.x="Name", by.y = "Var1", all.x = T)


####Calculate the incidence per block 
blocks@data$IncidenceTotal <- blocks@data$Total/blocks@data$population*100
blocks@data$IncidenceTotal[blocks@data$Incidence==Inf] <- NA





#count the number of cases with coordinates in each block for each week

for (i in c(201637:201652,201701:weekactuelle)){
      
      count <- over(casecoords[which(linelist$week==i)], blocks)
      count2 <- as.data.frame(table(count$Name))
      
      names(count2) <- c("Var1",paste0("FreqWeek ", i))
      
      
      ####Merge the blocks shapefile with casecount and block population data
      
      blocks <-  merge(blocks, count2, by.x="Name", by.y = "Var1", all.x = T)
      
      blocks@data[paste0("FreqWeek ", i)][is.na(blocks@data[paste0("FreqWeek ", i)])] <- 0
      
      if (i==201637){
        ####Calculate the incidence per block 
        blocks@data[paste0("IncidenceWeek", i)] <- blocks@data[paste0("FreqWeek ", i)]/blocks@data$population*100
        blocks@data[paste0("IncidenceWeek", i)][blocks@data[paste0("IncidenceWeek", i)]==Inf] <- NA
      }
}



#Do the cummulative incidence (by adding previous week cases on to the current week) 

for (i in c(201638:201652,201701:weekactuelle)){
      
      if (i==201701){
        blocks@data[paste0("FreqWeek ", i)] <- blocks@data[paste0("FreqWeek ", i)] + blocks@data[paste0("FreqWeek 201652")]
        
        ####Calculate the incidence per block 
        blocks@data[paste0("IncidenceWeek", i)] <- blocks@data[paste0("FreqWeek ", i)]/blocks@data$population*100
        blocks@data[paste0("IncidenceWeek", i)][blocks@data[paste0("IncidenceWeek", i)]==Inf] <- NA
        
      }
      
      else{  
  
      blocks@data[paste0("FreqWeek ", i)] <- blocks@data[paste0("FreqWeek ", i)] + blocks@data[paste0("FreqWeek ", i-1)]
      
      ####Calculate the incidence per block 
      blocks@data[paste0("IncidenceWeek", i)] <- blocks@data[paste0("FreqWeek ", i)]/blocks@data$population*100
      blocks@data[paste0("IncidenceWeek", i)][blocks@data[paste0("IncidenceWeek", i)]==Inf] <- NA
      }
}




#####perpare the shapefile for accepting data and plotting

#give each shape an id (necessary for plotting order later)
blocks@data$id <- as.numeric(row.names(blocks@data))

#backup the dataset with blocknames, cases, population and incidence in it
incidence  <- blocks@data

#transform the blocks dataset to be able to plot (with ggplot)
blocks <- fortify(blocks, region = "id")

#merge the transformed blocks shapefile with the incidence dataset
merge.shp.coef <-  merge(blocks, incidence, by="id", all.x=T)

#order the shapefile to have it in final plotting order
final.plot<-merge.shp.coef[order(merge.shp.coef$order), ] 




########Cleaning data water points####################

#remove missing from bottom of excel file
waterpoints <- waterpoints[which(!is.na(waterpoints$Number)),]

#clean to dataset and restructure
names(chlorination) <-  c(chlorination[3,1:5],chlorination[2,6:15])
chlorination <- chlorination[c(-1,-2,-3),]

######Merge water points gps and chlorination information
waterpoints <- merge(waterpoints, chlorination, by.x = "WP ID", by.y="Water Point", all.x=T)

#convert gps points to coordinate reference system of others
waterptslonglat <- SpatialPoints(cbind(lon = waterpoints$Longitude[!is.na(waterpoints$Longitude)&!is.na(waterpoints$Latitude)],
                                      lat = waterpoints$Latitude[!is.na(waterpoints$Longitude)&!is.na(waterpoints$Latitude)]),
                                proj4string=CRS("+proj=longlat"))

waterptcoords <- spTransform(waterptslonglat, CRS = blockpoints@proj4string)

#save coordinates with correct reference system back in to dataset
waterpoints <- cbind(waterpoints[!is.na(waterpoints$Latitude),], waterptcoords@coords)

#Create overarching yes/no for chlorination
waterpoints$chlorinated <- ifelse(waterpoints$Operationel=="O"&waterpoints$`MSF Bucket Chlorination (O/N)`=="O", "Chlorinated", 
                                                                                                              "Not Chlorinated")
waterpoints$chlorinated[waterpoints$Operationel=="N" | waterpoints$Operationel=="Broken"] <- "Out of Service"

# waterpoints$chlorinated <- ifelse(!is.na(waterpoints$'Week 45'), "Chlorinated", "Not Chlorinated")
# waterpoints$chlorinated[waterpoints$Operationel=="N" | waterpoints$Operationel=="Broken"] <- "Out of Service"











####################################################################################################################






                    #####           START MAPPING (edit the output address accordingly)






#####################################################################################################################











############ Get OpenStreetMap Background######################

#download map
map2 <- get_map(c(20.25,10.99,20.325,11.08), source = "google", maptype="roadmap", color = "bw")

# map2 <- get_map(c(20.25,10.99,20.325,11.08), source = "osm",color = "bw")


#put in ggplot
mapPoints <- ggmap(map2)

#calculate scalebar
bb <- attr(map2, "bb")
bb2 <- data.frame(long = unlist(bb[c(2, 4)]), lat = unlist(bb[c(1,3)]))












####################Weekly dot mapping########################



for (i in c(201635:201652,201701:weekactuelle)){
      
      linelist3 <- linelist[which(linelist$week <= i),]
      linelist3$currentweek <- ifelse(linelist3$`EpiWeek FIRST Assessment (Community or Medical)`==paste0(substr(i,0,4),"_",
                                                                                                               substr(i, 5,6)), 
                                                                                                        paste0("Week ", substr(i, 5,6)), 
                                     "Previous Weeks")
      linelist3$currentweek[is.na(linelist3$currentweek)] <- "Previous Weeks"
      
      
      
      dotmap <- mapPoints + 
        geom_jitter(data=linelist3, 
                              aes(x=lon, y=lat, fill=currentweek),shape=21, size=5, show.legend = T)+
        
        scale_fill_manual(values = c("dark grey", "red")) +
        scalebar(data = bb2, dist = 1, dd2km = TRUE, model  = "WGS84", 
                  anchor = c(x=20.28, y=10.995))+
        theme_nothing(legend = T)+
        theme(legend.title = element_blank(), legend.key = element_blank(), legend.text=element_text(size=25))
        
      
      ggsave(dotmap, file = paste0("C:/Users/Spina/Desktop/Am Timan/R stuff/Maps/DotMaps/dotmap", i,".png"), width = 15, height = 15)
      
}




#########Confirmed dots mapping####################



dotmap <- mapPoints + 
  geom_jitter(data=linelist[linelist$classification=="Suspect" | linelist$classification=="Not a Case",], 
              aes(x=lon, y=lat, fill=classification),alpha=0.5,shape=21, size=5, show.legend = T)+
  
  geom_jitter(data=linelist[linelist$classification=="Confirmed",], 
              aes(x=lon, y=lat, fill=classification),shape=21, size=5, show.legend = T)+ 
  
  scale_fill_manual(values = c("red","light green","light salmon")) +
  scalebar(data = bb2, dist = 1, dd2km = TRUE, model  = "WGS84", 
           anchor = c(x=20.28, y=10.995))+
  theme_nothing(legend = T)+
  theme(legend.title = element_blank(), legend.key = element_blank(), legend.text=element_text(size=25))


ggsave(dotmap, file = paste0("C:/Users/Spina/Desktop/Am Timan/R stuff/Maps/DotMapsConfirmed/ConfirmedCases.png"), width = 15, height = 15)















#Blocks cummulative incidence mapping per week#######

for (i in c(201637:201652,201701:weekactuelle)){

      incidencemap <- mapPoints +
        geom_polygon(data = final.plot, 
                     aes(x = long, y = lat, group = group, fill = final.plot[,paste0("IncidenceWeek",i)]),color = "lightgrey", size = 0.25)+
        
        scale_fill_gradient(name= "Incidence\nper 100 population",limits=c(0,16), low="white", high="Red", na.value="white")+
        
        
        scalebar(data = bb2, dist = 1, dd2km = TRUE, model  = "WGS84", 
                 anchor = c(x=20.28, y=10.995))+
        theme_nothing(legend = TRUE)+
        theme_nothing(legend = T)+
        theme(legend.text=element_text(size=20), legend.title=element_text(size=20), legend.key=element_blank())
      
      
      ggsave(incidencemap, file = paste0("C:/Users/Spina/Desktop/Am Timan/R stuff/Maps/IncidenceMapsPlain/incidencemap",i,".png"), width = 15, height = 15)
}





#WaterPoints blocks incidence mapping#####


waterpointsmap <- mapPoints +
  geom_polygon(data = final.plot, 
               aes(x = long, y = lat, group = group, fill = IncidenceTotal),color = "lightgrey", size = 0.25)+
  scale_fill_gradient(name= "Incidence\nper 100 population",limits=c(0,16), low="white", high="Dark Green", na.value="white")+
  
  # geom_polygon(data = catchment, aes(x = long, y = lat, show.legend=T),color="black", fill=NA)+
  
  
  geom_jitter(data=waterpoints, 
              aes(x=lon, y=lat, colour=chlorinated),shape=21, size=5, stroke=2,show.legend = T, alpha=0.5)+
  scale_color_manual(name="Water Points", values = c("dark grey", "red","light salmon"))+
  
  
  
  scalebar(data = bb2, dist = 1, dd2km = TRUE, model  = "WGS84", 
           anchor = c(x=20.28, y=10.995))+
  theme_nothing(legend = TRUE)+
  theme(legend.text=element_text(size=20), legend.title=element_text(size=20), legend.key=element_blank())


ggsave(waterpointsmap, file = "C:/Users/Spina/Desktop/Am Timan/R stuff/Maps/IncidenceMapsWaterPoints/incidencemapTotal.png", width = 15, height = 15)




#WaterPoints blocks incidence mapping - proportional to water output#####

waterpoints$`Output (Litres)` <- ifelse(is.na(waterpoints$`Week 52`), 0, as.numeric(waterpoints$`Week 52`))


waterpointsmap <- mapPoints +
  geom_polygon(data = final.plot, 
               aes(x = long, y = lat, group = group, fill = IncidenceTotal),color = "lightgrey", size = 0.25)+
  scale_fill_gradient(name= "Incidence\nper 100 population",limits=c(0,16), low="white", high="Dark Green", na.value="white")+
  
  # geom_polygon(data = catchment, aes(x = long, y = lat, show.legend=T),color="black", fill=NA)+
  
  
  geom_jitter(data=waterpoints, 
              aes(x=lon, y=lat, colour=chlorinated, size=`Output (Litres)`),shape=21, stroke=2,show.legend = T, alpha=0.5)+
  scale_color_manual(name="Water Points", values = c("blue", "red","light salmon"))+
  
  
  
  scalebar(data = bb2, dist = 1, dd2km = TRUE, model  = "WGS84", 
           anchor = c(x=20.28, y=10.995))+
  theme_nothing(legend = TRUE)+
  theme(legend.text=element_text(size=20), legend.title=element_text(size=20), legend.key=element_blank())


ggsave(waterpointsmap, file = "C:/Users/Spina/Desktop/Am Timan/R stuff/Maps/IncidenceMapsWaterPoints/incidencemapTotalVolume.png", width = 15, height = 15)










#####water chlorination by week with cummulative incidence#####





for (i in c(seq(201644, 201652))){

  waterpoints$chlorinated <- NA
  waterpoints$chlorinated <- ifelse(waterpoints[,paste0("Week ", substr(i, 5,6))]!="0"&
                                    !is.na(waterpoints[,paste0("Week ", substr(i, 5,6))]),"Chlorinated","Not Chlorinated")
  waterpoints$chlorinated[waterpoints[,paste0("Week ", substr(i, 5,6))]=="0"] <- "Out of Service" 
  

    waterpointsmap <- mapPoints +
  
                geom_polygon(data = final.plot, 
                             aes(x = long, y = lat, group = group, fill = final.plot[,paste0("IncidenceWeek",i)]),color = "lightgrey", size = 0.25)+
                
                scale_fill_gradient(name= "Incidence\nper 100 population",limits=c(0,16), low="white", high="Dark Green", na.value="white")+
                
                # geom_polygon(data = catchment, aes(x = long, y = lat, show.legend=T),color="black", fill=NA)+
  
  
                geom_jitter(data=waterpoints, 
                aes(x=lon, y=lat, colour=chlorinated),shape=21, size=5, stroke=2,show.legend = T, alpha=0.5)+
                scale_color_manual(name="Water Points", values = c("dark grey", "red","light salmon"))+
  
                
  
                scalebar(data = bb2, dist = 1, dd2km = TRUE, model  = "WGS84", 
                anchor = c(x=20.28, y=10.995))+
                theme_nothing(legend = TRUE)+
                theme(legend.text=element_text(size=20), legend.title=element_text(size=20), legend.key=element_blank())


    ggsave(waterpointsmap, file = paste0("C:/Users/Spina/Desktop/Am Timan/R stuff/Maps/IncidenceMapsWaterPoints/incidencemapWeek",i,".png"), width = 15, height = 15)

}

##to save as PDF
# pdf("D:/Users/HERP-epidem/Desktop/R stuff/mymap.pdf")
# print(incidencemap)
# dev.off()






















#Quartiers incidence map#####
# 
# 
# quartiercounts <- data.frame(table(linelist2$`Quartier/Village`))
# quartiercounts$Var1 <- toupper(quartiercounts$Var1)
# quartiercounts$Var1[quartiercounts$Var1=="AL-HOUGNA"] <- "AL HOUGNA"
# quartiercounts$Var1[quartiercounts$Var1=="AMSINENE"] <- "AM SINENE"
# quartiercounts$Var1[quartiercounts$Var1=="COMMERCANT"] <- "COMMERCIANTS"
# 
# 
# 
# output3 <- aggregate(output2$population, by=list(output2$Quartier), FUN=sum)
# 
# quartiers@data <- merge(quartiers@data, output3, by.x= "Name", by.y = "Group.1", all.x=T)
# 
# quartiers@data<- merge(quartiers@data, quartiercounts, by.x= "Name", by.y = "Var1", all.x=T)
# 
# 
# quartiers@data$Incidence <- quartiers@data$Freq/quartiers@data$population*100
# 
# blocks@data$Incidence[blocks@data$Incidence==Inf] <- NA
# 
# blocks@data$id <- as.numeric(row.names(blocks@data))
# 
# incidence  <- blocks@data
# 
# blocks <- fortify(blocks, region = "id")
# 
# merge.shp.coef <-  merge(blocks, incidence, by="id", all.x=T)
# 
# final.plot<-merge.shp.coef[order(merge.shp.coef$order), ] 
# 
# 













#Kernel density mapping 
# 
# mapPoints + 
#   geom_point(data=linelist, aes(x=lon, y=lat),colour="red",size=2) +
#   stat_density2d(data=linelist, aes(x=lon, y=lat, fill=..level..),binwidth = 200,alpha=0.3,geom = "polygon") 
# 







