#!/usr/bin/env python3
from numba import jit
from numba import __version__ as numbavers
''' shows that Numba 0.15.1 doesn't understand "is not None" '''

@jit
def nonetest(x=None):
    if x is not None:
        print(x)
    else:
        print('x was None')

if __name__ == '__main__':
    print('Numba version ' + str(numbavers))
    nonetest()
    nonetest(3)