#!/usr/bin/env python3
"""
benchmarks writing boolean array vs uint8 array of same values.
For high-speed in the loop writing where performance is critical.
"""

import tempfile
from numpy.random import random
from numpy import packbits
import h5py
from time import time

SIZE = (3, 200000)  # arbitrary size to test

# %% create random Boolean array
xb = random(SIZE) > 0.5  # mean ~ 0.5
xbl = xb.tolist()

with tempfile.NamedTemporaryFile() as fn:
    with h5py.File(fn, "w") as h:
        tic = time()
        h["bool"] = xb
        print(f"{time()-tic:3e} sec. to write boolean from Numpy bool")

        tic = time()
        xi = packbits(xbl, axis=0)  # each column becomes uint8 BIG-ENDIAN
        h["uint8"] = xi
        print(f"{time()-tic:3e} sec. to write uint8")
        # %% here's what nidaqmx gives us
        tic = time()
        h["listbool"] = xbl
        print(f"{time()-tic:3e} sec. to write boolean from bool list")
