#!/usr/bin/env python

#-------------
# Load modules
#-------------
import os
import sys
import time
from netCDF4 import Dataset
import numpy as np
import glob
import matplotlib.pyplot as plt            # pyplot module import
from matplotlib.ticker import ScalarFormatter, FormatStrFormatter


def calcPressureLevels(nlevs):
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
    ak   = np.zeros(nlevs+1)
    bk   = np.zeros(nlevs+1)
    phPa = np.zeros(nlevs)

    fileName = str(nlevs)+'-layer.p'

    fid = open(curDir+'/'+fileName, 'r')
    lnum = 0
    k = 0
    for line in fid:
        lnum += 1
        if (lnum > 2):
           line    = line.strip()
           columns = line.split()
           ak[k]   = float(columns[1])
           bk[k]   = float(columns[2])
           k      += 1
    fid.close()

    for k in range(nlevs):
        phPa[k] = 0.50*((ak[k]+ak[k+1])+0.01*1.00e+05*(bk[k]+bk[k+1]))

    return phPa[::-1]


# Start time
#-----------
start = time.clock()

vName = 'aoa'
begYear = 1990
endYear = 2009

firstFile = 0
ref_lat = -86.0

numDays = 0

coef = 365.5

print "-----------------------------"
print "Serial Time Series Processing"
print "-----------------------------"

# Loop over the years
#--------------------
for year in range(begYear, endYear+1):
    print "Processing files for ", year
    dirY = '/discover/nobackup/jkouatch/GEOSctmProduction/AOArun_new/holding/TR/'+ str(year)

    # Loop over the months
    #---------------------
    #for month in range(1,13):
    for month in range(1,13):
        dirM = dirY+str(month).zfill(2)+'/'
        listFiles = glob.glob(dirM+"AOArun.TR."+str(year)+str(month).zfill(2)+"*_1200z.nc4")

        numDays += len(listFiles)

        # Loop over the daily files
        #--------------------------
        for file in listFiles:
            # Open file
            #----------
            nf = Dataset(file, mode='r')

            # Extract information if it is the first file
            #--------------------------------------------
            if firstFile == 0:
               lons = nf.variables['lon'][:]
               lats = nf.variables['lat'][:]
               levs = nf.variables['lev'][::-1]
               nlons = np.size(lons)
               nlats = np.size(lats)
               nlevs = np.size(levs)

               levs = calcPressureLevels(nlevs)
               lat_index = (np.abs(lats - ref_lat)).argmin()

            # Read the daily average age of air
            #----------------------------------
            var = nf.variables[vName][0,::-1,lat_index,:] / coef

            # Determine the zonal mean
            #-------------------------
            tempVar = np.mean(var,axis=1)

            # Stack the daily values into an existing array
            #----------------------------------------------
            if firstFile == 0:
               firstFile = 1
               dataVal = tempVar
            else:
               dataVal = np.column_stack((dataVal,tempVar))
    
            # Close file
            #-----------
            nf.close()

days = [i+1 for i in range(numDays)]


# Plot the mean at a specified level
#-----------------------------------
figName  = 'fig_TimeSeries_AgeOfAir'

X, Y = np.meshgrid(np.array(days), levs)

fig = plt.figure(figsize=(13,13))

ax = fig.add_subplot(1,1,1)

CS = ax.contour(X, Y, dataVal)
ax.clabel(CS, inline=1, fontsize=10)
ax.set_title('Age-of-Air (years) at  $86^o$  S')
# y-axis
ax.set_yscale('log')
ax.set_ylim(plt.ylim()[::-1])
ax.set_ylabel('Pressure (hPa)')
ax.yaxis.set_major_formatter(FormatStrFormatter('%.2f'))

# x-axis
x_ticks = [day for day in days if day%365 == 0] # Only pull out full years
x_labels = [str(i+begYear) for i in range(len(x_ticks))]
ax.set_xticks(x_ticks)
ax.set_xticklabels(x_labels)
ax.set_xlabel('Year')
ax.xaxis.grid(True)


plt.savefig(figName+'.png')

#plt.show()

# End time
#-----------
finish = time.clock()

print
print 'Elapsed Time for the time series calculations: ', finish - start,'s'
print
