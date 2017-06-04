#!/usr/bin/env Rscript

library(ncdf4)
library(RColorBrewer)

calcPressureLevels <- function(nlevs) {
#    """
#      This function takes the number of vertical levels
#      to read a file that contains the values of ak and bk.
#      It then computes the pressure levels using the formula:
#
#          0.5*(ak[l]+ak[l+1]) + 0.1*1.0e5*(bk[l]+bk[l+1])
#
#      Input Varialble:
#        nlevs: number of vertical levels
#
#      Returned Value:
#        phPa: pressure levels from bottom to top
#    """
    ak   <- array(0.0, dim=c(nlevs+1))
    bk   <- array(0.0, dim=c(nlevs+1))
    phPa <- array(0.0, dim=c(nlevs))

    fileName <-  paste(toString(nlevs),'-layer.p', sep='')

    fid <- read.table(fileName, skip=2)
    for (k in 0:nlevs+1) {
        ak[k] <- fid[k,2]
        bk[k] <- fid[k,3]
    }

    for (k in 1:nlevs) {
        phPa[k] <- 0.50*((ak[k]+ak[k+1])+0.01*1.00e+05*(bk[k]+bk[k+1]))
    }

    return(rev(phPa))

}


# Start time
#-----------
btm <- proc.time()

cat("-----------------------------\n")
cat("Serial Time Series Processing\n")
cat("-----------------------------\n")

vName <- 'aoa'
begYear <- 1990
endYear <- 2009

firstFile <- 0

numDays <- 0
coef <- 365.5
set_lat = -86.0

# Loop over the years
#--------------------
for (year in begYear:endYear){
    cat("Processing files for Year", year, "\n")

    dirY <- paste('/discover/nobackup/jkouatch/GEOSctmProduction/AOArun_new/holding/TR/', toString(year), sep='')

    # Loop over the months
    #---------------------
    #for (month in 1:12){
    for (month in 1:12){
        dirM <- paste(dirY, sprintf("%02d", month), '/', sep='')
        list_files <- Sys.glob(paste(dirM, "AOArun.TR.", toString(year), sprintf("%02d", month), "*_1200z.nc4", sep=''))

        # Loop over the daily files
        #--------------------------
        for (file in list_files) {
            numDays <- numDays + 1
            # Open file
            #----------
            nf <- nc_open(file)

            # Extract information if it is the first file
            #--------------------------------------------
            if (firstFile == 0) {
               lons <- ncvar_get(nf, "lon") 
               lats <- ncvar_get(nf, "lat") 
               levs <- ncvar_get(nf, "lev")
               nlons <- dim(lons)
               nlats <- dim(lats)
               nlevs <- dim(levs)

               LatStartIdx <- which( nf$dim$lat$vals == set_lat)

               levs <- calcPressureLevels(nlevs)

               #dataVal <- array(0.0, dim=c(nlevs)) 
            }

            # Read the daily average age of air at latitute set_lat
            #------------------------------------------------------
            var <- ncvar_get(nf, vName)[, LatStartIdx,] / coef  

            # Determine the zonal mean
            #-------------------------
            tempVar <- apply(var, c(2), mean)
            tempVar <- rev(tempVar)              # reverse the vertical levels

            # Stack the daily values into an existing array
            #----------------------------------------------
            if (firstFile == 0) {
               dataVal <- tempVar
               firstFile <- 1
            }
            else {
               dataVal <- rbind(dataVal,tempVar)
            }
    

            # Close file
            #-----------
            nc_close(nf)
        }
    }
}

#-----------------------------------
# Plot the mean at a specified level
#-----------------------------------


# x-axis
#------
days <- 1:numDays
xtick <- pretty(days)
#x_ticks = [day for day in days if day%365 == 0] # Only pull out full years
#x_labels = [str(i+begYear) for i in range(len(x_ticks))]

# y-axis
#-------
pLevs <- 1:length(levs)
y_tick <- log10(levs)
#y_tick <- pretty(y_tick)

# Set the colormap
#-----------------
k <- 7
my.cols <- rev(brewer.pal(k, "RdYlBu"))

# Save the figure in a png file
#------------------------------
figName  <- 'fig_TimeSeries_AgeOfAir_R.png'
png(filename=figName,width=800,height=600,bg="white")

#par(ylog=TRUE, yaxp= c(levs[1], levs[nlevs], 5))
cat("\n")
cat("Days: ", length(days), "\n")
cat("levs: ", length(levs), "\n")
cat("dataVal: ", dim(dataVal), "\n")
cat("\n")

#contour(days, log10(levs), dataVal, 
        #xlim=c(1,length(days)),
        #col=my.cols,
        #log='y',
contour(days, pLevs, dataVal, 
        col=my.cols,
        xlab='Year', ylab='Pressure (hPa)',
        main="Age-of-Air (years) at 86^o S")
#axis(side=2, at = y_tick, labels = y_tick)

# End time
#-----------
etm <- proc.time()

cat(" \n")
cat("Elapsed Time for the time series calculations: \n")
etm - btm
cat(" \n")
