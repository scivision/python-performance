from numpy import empty,nan
def nans(shape=1, dtype=float, order='F'):
    a = empty(shape, dtype, order)
    a.fill(nan)
    return a

'''
faster than using nan*empty()
$ ipython
Python 3.4.2 |Anaconda 2.1.0 (64-bit)| (default, Oct 21 2014, 17:16:37) 
IPython 2.2.0 -- An enhanced Interactive Python.
from nans import nans
from numpy import empty,nan

%timeit nans((1000,1000))
100 loops, best of 3: 1.87 ms per loop

%timeit nan*empty((1000,1000))
100 loops, best of 3: 3.24 ms per loop
'''
