#!/usr/bin/env Rscript

#----------------
# Import packages
#----------------
library(foreach)
library(doParallel)
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

getLevels <- function(fileName) {
    library(ncdf4)
    nf <- nc_open(fileName)
    levs <- ncvar_get(nf, "lev")
    nlevs <- dim(levs)
    nc_close(nf)

    levs <- calcPressureLevels(nlevs)

    return(levs)
}


getDataFromFile <- function(fileName) {
    library(ncdf4)
    coef <- 365.5
    set_lat = -86.0

    nf <- nc_open(fileName)

    lats <- ncvar_get(nf, "lat")
    LatStartIdx <- which( nf$dim$lat$vals == set_lat)
    # Read the daily average age of air at latitute set_lat
    #------------------------------------------------------
    var <- ncvar_get(nf, vName)[, LatStartIdx,] / coef  #

    # Determine the zonal mean
    #-------------------------
    tempVar <- apply(var, c(2), mean)
    tempVar <- rev(tempVar)              # reverse the vertical levels

    nc_close(nf)

    #cat("tempVar: ", length(tempVar),"\n")
    return(tempVar)
}


# Start time
#-----------
btm <- proc.time()

cat("-------------------------------\n")
cat("Parallel Time Series Processing\n")
cat("-------------------------------\n")

vName <- 'aoa'
begYear <- 1990
endYear <- 2009

numDays <- 0

numThreads <- 20

dataVal <- {}

# Loop over the years
#--------------------
for (year in begYear:endYear){
    cat("Processing files for Year", year, "\n")

    dirY <- paste('/discover/nobackup/jkouatch/GEOSctmProduction/AOArun_new/holding/TR/', toString(year), sep='')

    # Loop over the months
    #---------------------
    for (month in 1:12){
        dirM <- paste(dirY, sprintf("%02d", month), '/', sep='')
        list_files <- Sys.glob(paste(dirM, "AOArun.TR.", toString(year), sprintf("%02d", month), "*_1200z.nc4", sep=''))

        numFiles <- length(list_files)
        numDays <- numDays + numFiles

        #cat("Number of files: ", numFiles, "\n")
        #tempVar <- vector("list", numFiles) 

        registerDoParallel(numThreads)

        # Loop over the daily files
        #--------------------------
        tempVar <- foreach(idx = 1:numFiles,
                           .combine = list, 
                           .multicombine = TRUE) %dopar% 
                   list(getDataFromFile(list_files[idx]))
        stopImplicitCluster()

        #print(tempVar)
        #cat("\n")
        #cat("\n")
        #print(tempVar[2])
        #cat("\n")

        # Stack the daily values into an existing array
        #----------------------------------------------
        if (length(dataVal) == 0) {
           dataVal <- unlist(tempVar[1])
           for (i in 2:numFiles) {
               dataVal <- rbind(dataVal,unlist(tempVar[i]))
           }
        }
        else {
           for (i in 1:numFiles) {
               dataVal <- rbind(dataVal,unlist(tempVar[i]))
           }
        }
    
    }
}

levs <- getLevels(list_files[1])

cat(" \n")
cat(" \n")
#print(dataVal[1])
#cat(" \n")
#cat(" \n")
#print(dataVal)

cat(" \n")
cat("Number of days: ", numDays, "\n")
cat(" \n")
cat("Dim of dataVal: ", dim(dataVal), nrow(dataVal), ncol(dataVal), "\n")
cat(" \n")
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
figName  <- 'fig_TimeSeries_AgeOfAir_R_para.png'
png(filename=figName,width=800,height=600,bg="white")

#par(ylog=TRUE, yaxp= c(levs[1], levs[nlevs], 5))

#contour(days, log10(levs), dataVal, 
contour(days, pLevs, dataVal, 
        xlim=c(1,length(days)),
        col=my.cols,
        #log='y',
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
