#!/usr/bin/env python
from numba import jit
from numba import __version__ as numbavers
import numpy as np
"""
This test was for a problem fixed after Numba 0.15.1
in version 0.15.1, it gave error
numba.lowering.LoweringError: Failed at object mode backend
Internal error:
ValueError: 'is not' is not in list

This is fixed now:
https://github.com/numba/numba/pull/857
"""


@jit(nopython=True)
def nonetest(x):
    if x is not None:
        print(x)
    else:
        print('x was None')

@jit(nopython=True)
def nantest(x):
    if not np.isnan(x):
        print(x)
    else:
        print('x is NaN')

if __name__ == '__main__':
    print('Numba version',numbavers)
    nonetest(None)
    nonetest(3)

    nantest(np.nan)
    nantest(float('nan'))
    #nantest(None) #this isn't possible even without Numba--typeError
    nantest(3)
