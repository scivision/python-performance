#!/usr/bin/env julia

#-------------
# Load modules
#-------------
using NetCDF

function calcPressureLevels(nlevs)
    """
      This function takes the number of vertical levels
      to read a file that contains the values of ak and bk.
      It then computes the pressure levels using the formula:

          0.5*(ak[l]+ak[l+1]) + 0.1*1.0e5*(bk[l]+bk[l+1])

      Input Varialble:
        nlevs: number of vertical levels

      Returned Value:
        phPa: pressure levels from bottom to top
    """
    ak   = zeros(Float32, nlevs+1)
    bk   = zeros(Float32, nlevs+1)
    phPa = zeros(Float32, nlevs)

    fileName = string(string(nlevs), "-layer.p")

    fid = open(fileName) ;
    lines = readlines(fid) ;
    lnum = 1 ;
    k = 1 ;
    for line in lines
        lnum += 1 ;
        if (lnum > 3)
           line    = strip(line) ;
           columns = split(line) ;
           ak[k]   = float(columns[2]) ;
           bk[k]   = float(columns[3]) ;
           k      += 1 ;
        end
    end
    close(fid);

    for k in 1:nlevs
        phPa[k] = 0.50*((ak[k]+ak[k+1])+0.01*1.00e+05*(bk[k]+bk[k+1]));
    end

    return phPa[nlevs:-1:1]
end


function getData(file)
   coef = 365.5
   vName = "aoa"
   ref_lat = -86.0

   #lats = ncread(file, "lat")
   #lat_index = findfirst(lats, ref_lat)
   #startList = [1,lat_index,1,1]
   startList = [1,5,1,1]
   countList = [-1,1,-1,1]

   # Read the daily average age of air
   var = ncread(file, vName, start=startList, count=countList) / coef

   # Determine the zonal mean
   tempVar = mean(var,1)
   tempVar = tempVar[1,1,:,1]

   return tempVar
end

function getLevels(file)
   levs = ncread(file, "lev")
   nlevs = length(levs)
   levs = vertLevels_GEOS.calcPressureLevels(nlevs)
   return levs
end 

# Start time
#-----------
tic()

begYear = 1990
endYear = 2009

firstFile = 0

numDays = 0

dataVal = zeros(72)

# Loop over the years
#--------------------
for year in begYear:endYear
    println( "Processing files for", year)
    dirY = "/discover/nobackup/jkouatch/GEOSctmProduction/AOArun_new/holding/TR/"* string(year)

    # Loop over the months
    #---------------------
    for month in 1:12
        dirM = dirY*lpad(string(month), 2, 0)*"/"
        listFiles = filter(x -> endswith(x, "_1200z.nc4"),  readdir(dirM))
      
        numDays = numDays + length(listFiles)

        # Loop over the daily files
        #--------------------------
        for fl in listFiles
            file = string(dirM, fl)

            tempVar = getData(file)

            if (firstFile == 0)
               levs = getLevels(file)
            end 
            # Stack the daily values into an existing array
            #----------------------------------------------
            dataVal = hcat(dataVal,tempVar)
    
        end
    end
end

# Remove the first row
#---------------------
dataVal = dataVal[setdiff(1:end, 1),:] # delete the first row

# Determine the vertical levels
#------------------------------
dirY = "/discover/nobackup/jkouatch/GEOSctmProduction/AOArun_new/holding/TR/"* string(endYear)
dirM = dirY*lpad(string(1), 2, 0)*"/"
file = "AOArun.TR."*string(endYear)*lpad(string(1),2,0)*lpad(string(1),2,0)*"_1200z.nc4"
levs = getLevels(string(dirM, file))
println(levs)

days = [i for i in 1:numDays]

# Plot the mean at a specified level
#-----------------------------------
figName  = "fig_TimeSeries_AgeOfAir"

###### COULD NOT DO THE CONTOUR PLOT

# End time
#-----------
toc()

