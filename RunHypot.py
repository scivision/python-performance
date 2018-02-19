#!/usr/bin/env python
"""
Compare speed of hypot(x,y) vs. sqrt(x**2 + y**2)
hypot() is faster for small arrays, but gets a little slower for large arrays.
Breakpoint around 10**5 elements on my PC.
"""
import subprocess
import numpy as np
from matplotlib.pyplot import figure,show
import timeit
import sys
try:
    import seaborn as sns
    sns.set_context('talk')
except ImportError:
    pass


def bench_hypot(N,Nrun):
    pyrat = np.empty(N.size)

    for i,n in enumerate(N):
        
        b = np.arange(n,dtype=float)
        print('N=',n)
        thy=timeit.repeat('np.hypot(a, b)',
                   'import gc; gc.enable();import numpy as np; a = np.arange({},dtype=float); b = a.copy()'.format(n),
                   repeat=Nrun, number=3*Nrun)

        tsq=timeit.repeat('np.sqrt(a**2+b**2)',
                   'import gc; gc.enable();import numpy as np; a = np.arange({},dtype=float); b = a.copy()'.format(n),
                    repeat=Nrun, number=3*Nrun)

        pyrat[i] = min(tsq) / min(thy)

    return pyrat


def plotspeed(N,pyrat,fortrat):
    pyver = sys.version_info
    pyver = '{}.{}.{}'.format(pyver[0],pyver[1],pyver[2])

    ax = figure().gca()
    ax.plot(N, pyrat)
    ax.set_title('timeit(sqrt(a**2+b**2)) / timeit(hypot(a,b)) \n Numpy {} Python {}'.format(np.__version__,pyver))
    ax.set_xscale('log')
    ax.legend(loc='best')
    ax.grid(True,which='both')
    ax.set_xlabel('N length of vectors a,b')
    show()

def benchmark_hypot_fortran(N, Nrun):
    fortrat = np.empty(N.size)
    for n in N:
        r = subprocess.check_output(['./bin/hypot', str(n), str(Nrun)], universal_newlines=True)
        print(r)


if __name__ == '__main__':
    Nrun = 3
    N = np.logspace(1,6.5,20,True,dtype=int)

   
    pyrat = bench_hypot(N, Nrun)
    benchmark_hypot_fortran(N, Nrun)

    plotspeed(N,pyrat,None)
