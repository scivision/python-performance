#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["h5py", "numpy"]
# ///

"""
benchmarks writing boolean array vs uint8 array of same values.
For high-speed in the loop writing where performance is critical.
"""

import tempfile
import time

from numpy.random import random
from numpy import packbits
import h5py


SIZE = (3, 200000)  # arbitrary size to test

# %% create random Boolean array
xb = random(SIZE) > 0.5  # mean ~ 0.5
xbl = xb.tolist()

with tempfile.NamedTemporaryFile(suffix=".h5") as fn:
    with h5py.File(fn, "w") as h:
        tic = time.monotonic()
        h["bool"] = xb
    toc = time.monotonic()
    print(f"{toc-tic:3e} sec. to write boolean from Numpy bool")

    with h5py.File(fn, "w") as h:
        tic = time.monotonic()
        xi = packbits(xbl, axis=0)  # each column becomes uint8 BIG-ENDIAN
        h["uint8"] = xi
    toc = time.monotonic()
    print(f"{toc-tic:3e} sec. to write uint8")

    with h5py.File(fn, "w") as h:
        # %% here's what nidaqmx gives us
        tic = time.monotonic()
        h["listbool"] = xbl
    toc = time.monotonic()
    # outside context manager to help ensure HDF5 file is finalized
    print(f"{toc-tic:3e} sec. to write boolean from bool list")
