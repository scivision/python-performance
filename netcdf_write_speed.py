#!/usr/bin/env python
"""
benchmarks writing boolean array vs uint8 array of same values.
For high-speed in the loop writing where performance is critical.
"""
from tempfile import mkstemp
from numpy.random import random
from numpy import packbits
import xarray
from time import time

SIZE = (3,200000) # arbitrary size to test

#%% create random Boolean array
xb = (random(SIZE) >0.5)   # mean ~ 0.5
xbl = xb.tolist()
Xb = xarray.DataArray(xb,name='bool')


fn = mkstemp('.h5')[1]

tic = time()
Xb.to_netcdf('out.nc','w',encoding={'bool':{'fletcher32':True}})
print(f'{time()-tic:3e} sec. to write boolean from Numpy bool',fn)

tic = time()
xi = packbits(xbl,axis=0) # each column becomes uint8 BIG-ENDIAN
Xi = xarray.DataArray(xi)
Xi.to_netcdf('out.nc','a',encoding={'uint8':{'fletcher32':True}})
print(f'{time()-tic:3e} sec. to write uint8',fn)
#%% here's what nidaqmx gives us
tic = time()
Xbl = xarray.DataArray(xbl)
Xbl.to_netcdf('out.nc','a',encoding={'listbool':{'fletcher32':True}})
print(f'{time()-tic:3e} sec. to write boolean from bool list',fn)
