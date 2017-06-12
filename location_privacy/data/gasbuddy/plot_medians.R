#!/usr/bin/Rscript

# Create Line Chart

png("medians.png")

input <- file("tabulated_medians.csv", "r")
Data <- read.csv(input)

yrange <- c(0,max(Data$distance))
xrange <- c(0,10000)

numcities <- max(Data$location)

plot(xrange,yrange,xlab="Maximum error (m)", 
  ylab="Edit distance")
colors <- rainbow(numcities+1)
linetype <- c(0:numcities)
plotchar <- seq(18,18+numcities,1)

# Add lines for each city
for (i in 0:3) {
    city <- subset(Data, location==i)
    lines(city$skew, city$distance, lwd=1.5,
      lty=linetype[i], col=colors[i], pch=plotchar[i])
}


# add a title
title("Location data versus median error")

legend(xrange[1],yrange[2],0:3,cex=0.8,col=colors,
	pch=plotchar,lty=linetype,title="Tree")

dev.off()
