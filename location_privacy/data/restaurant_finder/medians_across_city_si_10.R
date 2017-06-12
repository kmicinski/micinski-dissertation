# Create Line Chart

jpeg("./../restaurant_finder/medians_across_city_si_10.jpg")

# convert factor to numeric for convenience 
Medians <- read.csv("./../restaurant_finder/medians_across_city_si_10.csv")
nlocations <- length(unique(Medians$location))
locations <- unique(Medians$location)

# get the range for the x and y axis 
xrange <- range(Medians$skew)
yrange <- range(Medians$distortion)

# set up the plot 
plot(xrange, yrange, type="n", xlab="maximum error (m)", log="x",
  	      ylab="edit distance") 
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
title("edit distance vs. maximum error")

# add a legend 
legend(xrange[1], yrange[2], locations, cex=0.8, col=colors,
  		   pch=plotchar, lty=linetype, title="City")

dev.off()
