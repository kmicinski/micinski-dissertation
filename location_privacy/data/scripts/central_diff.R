# Code for calculating central difference

library("sfsmisc")

kCutoffAddDist <- 1.0
kCutoffSetIntPercent <- .80

WriteColToKneesFile <- function(name,skew,app,metric,calculation) {
  f <- file("knees.txt","a")
  write(matrix(c(name,skew,app,metric,calculation),ncol = 5)
        ,f
        ,sep="\t")
  close(f)
}

CalculateCentralDifference <- function(x,y) {
  # Calculate the central difference of a set of points given in a
  # vector.
  # 
  # Args:
  #   x: Input vector
  #   y: Vector of skews
  # Returns:
  #   Vector representing central difference between points in x.
  #
  if (length(x) < 3) {
    stop("Argument x must have at least three points, given ",
         length(x))
  }
  central.difference <- c(1:(length(x)-2))
  for (i in 2:(length(x)-1)) {
    forward <- (x[i+1]-x[i])/((y[i+1]-y[i])*2)
    backward <- (x[i]-x[i-1])/((y[i]-y[i-1])*2)
    central.difference[i-1] <- ((forward -  backward)/(y[i+1]-y[i-1]))
    #central.difference[i-1] <- x[i+1]*y[i+1] + x[i-1]*y[i+1] - 2 * x[i] * y[i]
  }
  return(central.difference)
}

CalculateKnee <- function(city,app,name,metric) {
  # Calculate the "knee" in the plot for a given city.
  # 
  # Args:
  #  city: the data for the city
  # 
  # Returns:
  #  The skew at which the central difference is maximized
  #
  second.deriv <- CalculateCentralDifference(city$distortion, city$skew)
  #print(name)
  #bsecond.deriv <- D2ss(city$distortion, city$skew)$y
  #print(second.deriv)
  #csecond.deriv <- D2ss(city$skew,city$distortion)$y
  #print(name)
  #print(asecond.deriv)

  #print(c(name,city$skew[which.max(abs(second.deriv))+1]))
  
  if (max(city$distortion) == 0) {
    # Just go to the end of the zeros
    max <- max((subset(city,distortion==0))$skew)
  } else {
    max <- city$skew[which.max(abs(second.deriv))+1]
  }
  
  # Write data to file
  WriteColToKneesFile(name,max,app,metric,"finitediff")
  
  # Calculate cutoff metric
  if (metric=="additional") {
    # Additional distance metric, cutoff after kCutoffAddDist
    if (is.na(which(city$distortion>kCutoffAddDist)[1])) {
      # Do nothing
   } else {
      # Cutoff is first tpoint where additional distance is over kCutoffAddDist
      cutoff <- city$skew[which(city$distortion>kCutoffAddDist)[1]]
      WriteColToKneesFile(name, cutoff, app, metric, "cutoff")
    }
  } else {
    ## if (is.na(which[distortion>kCutoffAddDist][1])) {
    ##   # Do nothing
    ## }    
    # Set intersection metric, cutoff after 
    cutoff <- city$skew[which(city$distortion<(.75*city$distortion[1]))[1]]
    WriteColToKneesFile(name, cutoff, app, metric, "cutoff")
  }
  
  return(max)
}

