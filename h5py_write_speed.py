#!/usr/bin/env python
"""
benchmarks writing boolean array vs uint8 array of same values.
For high-speed in the loop writing where performance is critical.
"""
from tempfile import mkstemp
from numpy.random import random
from numpy import packbits
import h5py
from time import time

SIZE = (3, 200000)  # arbitrary size to test

# %% create random Boolean array
xb = random(SIZE) > 0.5  # mean ~ 0.5
xbl = xb.tolist()

fn = mkstemp(".h5")[1]
with h5py.File(fn, "w") as f:
    tic = time()
    f["bool"] = xb
    print(f"{time()-tic:3e} sec. to write boolean from Numpy bool", fn)

    tic = time()
    xi = packbits(xbl, axis=0)  # each column becomes uint8 BIG-ENDIAN
    f["uint8"] = xi
    print(f"{time()-tic:3e} sec. to write uint8", fn)
    # %% here's what nidaqmx gives us
    tic = time()
    f["listbool"] = xbl
    print(f"{time()-tic:3e} sec. to write boolean from bool list", fn)
