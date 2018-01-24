library(mclust)

# create some data for example purposes -- you have your read.csv(...) instead.
myData <- data.frame(x=runif(100),y=runif(100),z=runif(100))
# get parameters for most optimal model
myMclust <- Mclust(myData)
# if you wanted to do your summary like before:
mySummary <- summary( myMclust$BIC, data=myData )

# add a column in myData CLUST with the cluster.
myData$CLUST <- myMclust$classification

myData$PROB <- myMclust$z

# now to write it out:
write.csv(myData[,c("CLUST","PROB","x","y","z")], # reorder columns to put CLUST first
          file="out.csv",                  # output filename
          row.names=FALSE,                 # don't save the row numbers
          quote=FALSE)                     # don't surround column names in ""


# Example data
set.seed(101)
data = c(rnorm(100, mean = 10), rnorm(30, mean = 20), rnorm(50, mean = 15))
hist(data)

# Run Mclust
mixmdl = Mclust(data)

summary(mixmdl)

# Show means of fitted gaussians
print( mixmdl$parameters$mean ) 

