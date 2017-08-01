# Work done by Alex Spina
# Version 1.0



library(xlsx)
library(reshape2)
library(data.table)
library(sp)
library(rgdal)
library(ggplot2)
source("C:/Users/Spina/Desktop/Am Timan/R stuff/UsefulRscripts/functions/read_excel2.R")



###################read the data files#########################################################
blocklist <- read_excel2("C:/Users/Spina/Desktop/Am Timan/Desktop/Final Match List.xlsx")
blocklist <- blocklist[which(blocklist$Block!="."),]

population <- read_excel2("C:/Users/Spina/Desktop/Am Timan/Data Old versions/Supervisor Sum of ACo Activities/Superviseur ACo Daily Data Entry Form_05Jan2017.xlsx")

rm(dff)


#########Reading in kml files from google earth

# list all the layers in the kml file 
# ogrListLayers(dsn = "D:/Users/HERP-epidem/Documents/Epi Data/Maps/doc.kml")



#######read in shapefile for catchment area
catchment <- readOGR(dsn = "C:/Users/Spina/Desktop/Am Timan/Data Old versions/Maps/doc.kml", layer = "Catchment Area")


#######read in the shapefile for Quartiers
quartiers <- readOGR(dsn = "C:/Users/Spina/Desktop/Am Timan/Data Old versions/Maps", layer = "Quartiersshape")

#######read in the shapefile for blocks 
blocks <- readOGR(dsn = "C:/Users/Spina/Desktop/Am Timan/Data Old versions/Maps", layer = "Blocksshape")



#######read in the layer with block numbers and transform to coordinate system of others
blockpoints <- readOGR(dsn = "C:/Users/Spina/Desktop/Am Timan/Data Old versions/Maps/doc.kml", layer = "Block Numbers")





###############################################################################################################################













###Version 1: Population block counts from supervisor form ################



#clean the datafiles 
names(population) <- population[1,]

population <- population[c(-1,-2),]
population$Date <- excel_dates2(population$Date)
population <- population[which(population$Date <= as.Date("2016-11-30") & population$Bloc != 0 & population$Bloc != "."),]
population$`Total de personnes dans le bloc` <- as.numeric(population$`Total de personnes dans le bloc`)

#Create output file which will use later to merge and have a final dataset
output <- as.data.frame(unique(blocklist$Block[!is.na(blocklist$Block)]))
names(output) <- "Bloc"

######Create the counts dataset using the population dataset (supervisor form)

#create var counting number of doubles (for each row where a variable is doubled, consecutively count)
population$count <- 0
for (i in unique(population$Bloc)){
  population[population$Bloc==i,"count"] <- 1:nrow(population[population$Bloc==i,])
}

#put groupings of doubles in to single row 
population2<-dcast(population, Bloc~count, value.var="Total de personnes dans le bloc")

#name columns accordingly
colnames(population2)<-c("Bloc",paste0("Count", 1:(ncol(population2)-1)))


#make a column with the median count 
population2$Median <- apply(population2[,2:25],1,median, na.rm = T)
population2$Min <- apply(population2[,2:25],1,min, na.rm = T)
population2$Max <- apply(population2[,2:25],1,max, na.rm = T)





##################merge counts data with output dataset (to see which blocks are missing)

output <-  merge(output, population2, by = "Bloc", all.x =T)

output <-  merge(output, blocklist[,c("Block", "No. Houses")], by.x = "Bloc", by.y = "Block", all.x =T)


output$`No. Houses`[output$`No. Houses`==0] <- NA
output$perhouse <- output$Max/output$`No. Houses`


# write.xlsx(output, "D:/Users/HERP-epidem/Desktop/AmTiman_populationCountsByBlock.xlsx", row.names = F, showNA = F)



# missedblocs <- as.character(output$Bloc[is.na(output$Count1)])





##########Version 2: Davids house counts############################


output2 <- blocklist[,c(1,2)]

output2$population <- round(output2$`No. Houses`*5.8, digits=0)

output2$Block <- paste0("Block ", output2$Block)


zeroblocs <- as.character(output2$Block[output2$`No. Houses`==0])






#### Merging population and shapefiles for quartiers and blocknames



##Change shapefiles to all have the same geographic projection 

catchment <- spTransform(catchment, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
catchment <- fortify(catchment)

quartiers <- spTransform(quartiers, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
blockpoints <- spTransform(blockpoints, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))






########label the blocks shapefile with the blockpoints which are in them

#find block labels (points) which are in blocks polygons
wtf <- gIntersects(blockpoints, blocks, byid = T)

#create list of rows which mach in both datasets above
matchers <- which(wtf==TRUE, arr.ind = T)


#name the block polygons in the shapefile based on matching rows
blocks$Name <- "Missing"

for (i in 1:nrow(matchers)){
  blocks$Name[matchers[i,1]] <- as.character(blockpoints$Name[matchers[i,2]])
}





#find blocks polygons in shapefile polygons 
wtf2 <- gIntersects(blocks, quartiers, byid=T)

#create list of rows which match in each dataset
matchers2 <- which(wtf2==TRUE, arr.ind=T)


#match blocks to quartiers

blocks$Quartier <- "Missing"


for (i in 1:nrow(matchers2)){
  blocks$Quartier[matchers2[i,2]] <- as.character(quartiers$Name[matchers2[i,1]])
}


output2 <- merge(output2, blocks@data[,c("Name", "Quartier")], by.x="Block", by.y="Name", all.x=T)

output2 <- output2[which(!duplicated(output2$Block)),]



# quartspop <- aggregate(output2$population, by=list(output2$Quartier), FUN=sum)

# write.xlsx(quartspop, "C:/Users/Spina/Desktop/Am Timan/PopulationEstimate.xlsx")
