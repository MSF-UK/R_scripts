# Problem
library("poppr")
collected <- read.genalex("DataBinaryT-seasons-justV.csv")
aboot(collected, dist = provesti.dist, sample = 200, tree = "nj", cutoff = 50, quiet = TRUE)

# Solution
collected.df <- read.csv("DataBinaryT-seasons-justV.csv", 
                         skip = 2, 
                         header = TRUE, 
                         check.names = FALSE)
colnames(collected.df) <- gsub("[.]", "_", colnames(collected.df))
collected <- df2genind(collected.df[, -c(1:2)], 
          ind.names = collected.df[[1]], 
          strata = data.frame(pop = collected.df[[2]]),
          type = "PA",
          ncode = 1L)
collected <- as.genclone(collected)
locNames(collected)
aboot(collected, dist = provesti.dist, sample = 200, tree = "nj", cutoff = 50, quiet = TRUE)
