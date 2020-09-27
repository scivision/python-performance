#!/usr/bin/env python3
"""
benchmarks writing boolean array vs uint8 array of same values.
For high-speed in the loop writing where performance is critical.

0.146 sec. to write boolean from Numpy bool
0.021 sec. to write uint8
0.026 sec. to write boolean from bool list

So it seems even including time to pre-pack in uint8 is the way to go.

benchmark includes time to finalize NetCDF4 file.

NOTE: use NamedTemporaryFile to avoid fallback to scipy backend which is very feature-limited
"""

import tempfile
from numpy.random import random
from numpy import packbits
import xarray
from time import time
import os


SIZE = (3, 200000)  # arbitrary size to test

# %% create random Boolean array
xb = random(SIZE) > 0.5  # mean ~ 0.5
xbl = xb.tolist()
Xb = xarray.DataArray(xb, name="bool")


with tempfile.NamedTemporaryFile(suffix=".nc", delete=False) as f:
    tic = time()
    Xb.to_netcdf(f.name, "w")
os.unlink(f.name)
print(f"{time()-tic:.3f} sec. to write boolean from Numpy bool")

with tempfile.NamedTemporaryFile(suffix=".nc", delete=False) as f:
    tic = time()
    xi = packbits(xbl, axis=0)  # each column becomes uint8 BIG-ENDIAN
    Xi = xarray.DataArray(xi, name="uint8")
    Xi.to_netcdf(f.name, "w", engine="netcdf4")
os.unlink(f.name)
print(f"{time()-tic:.3f} sec. to write uint8")
# %% here's what nidaqmx gives us
with tempfile.NamedTemporaryFile(suffix=".nc", delete=False) as f:
    tic = time()
    Xbl = xarray.DataArray(xbl, name="listbool")
    Xbl.to_netcdf(f.name, "w")
os.unlink(f.name)
print(f"{time()-tic:.3f} sec. to write boolean from bool list")
