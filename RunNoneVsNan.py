#!/usr/bin/env python
import numba
import numpy as np
import timeit
import sys
import math
from argparse import ArgumentParser
"""
Test speed of None vs. NaN

 ./RunNoneVsNan.py
Numba version 0.37.0
Python version 3.6.4 |Anaconda, Inc.| (default, Mar 13 2018, 01:15:57)
[GCC 7.2.0]
--> Numba NaN sentinel: 2.430001586617436e-07
--> Numba None sentinel: 4.84999873151537e-07
--> CPython NaN sentinel: 1.1010001799149904e-06
--> CPython None sentinel: 2.100000529026147e-07

Numba gives ~20x speed up on isnan(), making it like "is None"
"""


p = ArgumentParser()
p.add_argument('Nrun', type=int, nargs='?', default=3)
p = p.parse_args()

print('Numba version', numba.__version__)
print('Python version', sys.version)

x = np.nan

print('--> Numba NaN sentinel: ', end='')
t = timeit.repeat(f'nantest()',
                  'import gc; gc.enable(); from __main__ import nantest',
                  repeat=p.Nrun, number=1)

print(min(t))

# %%

print('--> Numba None sentinel: ', end='')
t = timeit.repeat(f'nonetest()',
                  'import gc; gc.enable(); from __main__ import nonetest',
                  repeat=p.Nrun, number=1)

print(min(t))

# %%

print('--> CPython NaN sentinel: ', end='')
t = timeit.repeat(f'pynantest()',
                  'import gc; gc.enable(); from __main__ import pynantest',
                  repeat=p.Nrun, number=1)

print(min(t))

# %%

print('--> Numpy NaN sentinel: ', end='')
t = timeit.repeat(f'numpynantest()',
                  'import gc; gc.enable(); from __main__ import numpynantest',
                  repeat=p.Nrun, number=1)

print(min(t))

# %%

print('--> CPython None sentinel: ', end='')
t = timeit.repeat(f'pynonetest()',
                  'import gc; gc.enable(); from __main__ import pynonetest',
                  repeat=p.Nrun, number=1)

print(min(t))


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
