#!/usr/bin/env python3
"""
Test speed of None vs. NaN
"""

import numpy as np
import timeit
import sys
import math
from argparse import ArgumentParser

try:
    import numba

    print("Numba version", numba.__version__)
except (ImportError, OSError):
    numba = None
print("Python version", sys.version)
print("Numpy version", np.__version__)


P = ArgumentParser()
P.add_argument("Nrun", type=int, nargs="?", default=100000)
p = P.parse_args()

x = 0.0

if numba is not None:

    @numba.jit(nopython=True)
    def nonetest():
        return x is not None

    @numba.jit(nopython=True)
    def nantest():
        return np.isnan(x)


def pynonetest():
    return x is not None


def pynantest():
    return math.isnan(x)


def numpynantest():
    return np.isnan(x)


if numba is not None:
    print("--> Numba NaN sentinel: ", end="")
    t = timeit.repeat(
        "nantest()",
        "import gc; gc.enable(); from __main__ import nantest",
        repeat=p.Nrun,
        number=1,
    )

    print(f"{min(t):0.2e}")

    # %%

    print("--> Numba None sentinel: ", end="")
    t = timeit.repeat(
        "nonetest()",
        "import gc; gc.enable(); from __main__ import nonetest",
        repeat=p.Nrun,
        number=1,
    )

    print(f"{min(t):0.2e}")

# %%

print("--> CPython NaN sentinel: ", end="")
t = timeit.repeat(
    "pynantest()",
    "import gc; gc.enable(); from __main__ import pynantest",
    repeat=p.Nrun,
    number=1,
)

print(f"{min(t):0.2e}")

# %%

print("--> Numpy NaN sentinel: ", end="")
t = timeit.repeat(
    "numpynantest()",
    "import gc; gc.enable(); from __main__ import numpynantest",
    repeat=p.Nrun,
    number=1,
)

print(f"{min(t):0.2e}")

# %%

print("--> CPython None sentinel: ", end="")
t = timeit.repeat(
    "pynonetest()",
    "import gc; gc.enable(); from __main__ import pynonetest",
    repeat=p.Nrun,
    number=1,
)

print(f"{min(t):0.2e}")
