#!/usr/bin/env python3
from numba import jit
from numba import __version__ as numbavers
import numpy as np
''' shows that Numba 0.15.1 doesn't understand "is not None" '''

''' uncomment @jit to show error'''
#@jit
def nonetest(x=None):
    ''' In Numba 0.15.1, this is known to give error:
    numba.lowering.LoweringError: Failed at object mode backend
    Internal error:
    ValueError: 'is not' is not in list
    '''
    if x is not None:
        print(x)
    else:
        print('x was None')

#@jit
def nantest(x=np.nan):
    if not np.isnan(x):
        print(x)
    else:
        print('x is NaN')

if __name__ == '__main__':
    print('Numba version ' + str(numbavers))
    nonetest()
    nonetest(3)

    nantest()
    nantest(float('nan'))
    #nantest(None) #this isn't possible even without Numba--typeError
    nantest(3)