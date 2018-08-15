#!/usr/bin/env python
from numpy import empty, nan


def nans(shape=1, dtype=float, order='F'):
    a = empty(shape, dtype, order)
    a.fill(nan)
    return a


'''
faster than using nan*empty()
$ ipython
Python 3.6.1 |Continuum Analytics, Inc.| (default, Mar 22 2017, 19:54:23)
IPython 6.0.0

from nans import nans; from numpy import empty,nan

%timeit nans((1000,1000))
428 µs ± 15.3 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)

%timeit nan*empty((1000,1000))
1.31 ms ± 7.31 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
'''
