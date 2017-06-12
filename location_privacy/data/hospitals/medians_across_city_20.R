# Create Line Chart

jpeg("./../hospitals/medians_across_city_20.jpg")

# convert factor to numeric for convenience 
Medians <- read.csv("./../hospitals/medians_across_city_20.csv")
locations <- c("new_york","dallas","baltimore","newhaven","redmond","decatur")
nlocations <- length(locations)

# get the range for the x and y axis 
xrange <- range(Medians$skew)
yrange <- range(Medians$distortion)

# set up the plot 
plot(xrange, yrange, type="n", xlab="Maximum error (m)", log="x",
  	      ylab="Edit distance") 
colors <- rainbow(nlocations)
linetype <- c(1:nlocations) 
plotchar <- seq(18,18+nlocations,1)

# add lines 
for (i in 1:nlocations) { 
  city <- subset(Medians, location==locations[i])
  lines(sort(city$skew), sort(city$distortion), type="b", lwd=1.5,
    lty=linetype[i], col=colors[i], pch=plotchar[i])
} 

# add a title and subtitle 
title("")

# add a legend 
legend(xrange[1], yrange[2], locations, cex=0.8, col=colors,
  		   pch=plotchar, lty=linetype, title="City")

dev.off()
