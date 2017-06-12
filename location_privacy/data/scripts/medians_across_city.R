# Additional distance line plot

source("central_diff.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 5) {
  stop("Usage: ... [dataset] [jpeg] [title] [label] [metric]")
}

metric <- args[5]
medians <- read.csv(args[1])
png(file=args[2],width=1000,height=1200)
#jpeg(args[2])
par(mar=c(6,6,6,2))

# convert factor to numeric for convenience 
locations.full <- c("new_york","dallas","baltimore","newhaven","redmond","decatur")
locations.names <- c("New York", "Dallas", "Baltimore", "Newhaven", "Redmond", "Decatur")

locations <- levels(medians$location)
nlocations <- length(locations)

# get the range for the x and y axis 
xrange <- c(.1,50)

if (metric=="set") {
  yrange <- c(0,1)
} else {
  yrange <- range(na.omit(medians$distortion))
}

par.settings = list(axis.line=list(lwd=4))

print(xrange)
print(yrange)

par(mai=c(5,5,5,5))
par(mar=c(10,10,10,10))
par(mgp=c(6,2,0))

# set up the plot 
plot(xrange, yrange, type="n", xlab="Location truncation (km)", log="x",
     cex.lab=4.0, cex.axis=4.0, cex.main=3.5, cex.sub=3.5,
     xpd=NA, ylab=args[4])
    
colors <- rainbow(6)
linetype <- 1:6
plotchar <- 1:6

# Desired cities to draw knee lines
knees.cities <- c('decatur', 'new_york')
knees.styles <- c('dashed', 'dotted')

max.centdiff <- c(1:nlocations)

# add lines 
for (i in 1:nlocations) { 
  city.name <- locations[i]
  city <- subset(medians, location==locations[i])
  ltypch <- which(locations.full == city.name)
  lwd <- 8.0
  cex <- 3.0

  if (!is.na(city$distortion[1])) {
    if (metric=="set") {
      print("here")
      if (city$distortion[1] > 0) {
        city$distortion <- mapply(function(x) (x/(city$distortion[1])),city$distortion)
        lines(city$skew, city$distortion, type="b", lwd=lwd,
              cex=cex, lty=ltypch, col=colors[ltypch], pch=ltypch)
      }
    }
    else {
      print(c(locations[i],city$distortion))
      lines(city$skew, city$distortion, type="b", lwd=lwd,
            cex=cex, lty=ltypch, col=colors[ltypch], pch=ltypch)
    }
    max.centdiff[i] <- CalculateKnee(city,args[3],locations[i],metric)
  }
}

# Plot the min and max central differences
max <- which.max(max.centdiff)
min <- which.min(max.centdiff)

# XXX: Not plotting lines for now.
if (max==min) {
  # All max points are the same.
    ## abline(v = CalculateKnee(city,args[3],locations[i],args[4]),
    ##        lwd = 10.0)
    #lty = (knees.styles[i]))
} else {
  # Two distinct points.
  for (i in c(min,max)) {
    city <- subset(medians, location==locations[i])
    ## abline(v = CalculateKnee(city,args[3],locations[i],args[4]),
    ##        col = colors[i],
    ##        lty = "dashed",
    ##        lwd = 10.0)
    #lty = c("dotted", "dashed")[i])
  }
}

# add a title and subtitle 
title(args[3], cex.main = 4, font.main= 4)

# add a legend 
if (metric=="set") {
  place <- "bottomleft"
} else if (metric=="edit") {
  place <- "bottomright"
} else {
  place <- "topleft"
}

#if (args[3] == "Gasbuddy") { 
  # This app is irregular, label its axes
  legend(place, locations.names, cex=3, col=colors,
         lwd=5.0, pch=plotchar, lty=linetype, title="City")
#}

dev.off()
