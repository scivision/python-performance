#!/usr/bin/env python
"""
Compare speed of hypot(x,y) vs. sqrt(x**2 + y**2)
hypot() is faster for small arrays, but gets a little slower for large arrays.
Breakpoint around 10**5 elements on my PC.
"""
import subprocess
import numpy as np
import timeit
import sys
try:
    from matplotlib.pyplot import figure,show
except (ImportError,RuntimeError):
    figure=show=None

def bench_hypot(N,Nrun):
    pyrat = []

    for i,n in enumerate(N):
        print('N=',n)
        thy=timeit.repeat('np.hypot(a, b)',
               'import gc; gc.enable();import numpy as np; a = np.arange({},dtype=float); b = a.copy()'.format(n),
               repeat=Nrun, number=3*Nrun)

        tsq=timeit.repeat('np.sqrt(a**2+b**2)',
               'import gc; gc.enable();import numpy as np; a = np.arange({},dtype=float); b = a.copy()'.format(n),
               repeat=Nrun, number=3*Nrun)

        pyrat.append(min(tsq) / min(thy))

    return pyrat


def plotspeed(N,pyrat,fortrat):
    pyver = sys.version_info
    pyver = '{}.{}.{}'.format(pyver[0],pyver[1],pyver[2])
    
    fortver = subprocess.check_output(['gfortran','--version'], universal_newlines=True).split('\n')[0].split(' ')[-1]


    ax = figure().gca()
    
    ax.plot(N, pyrat, label='Python')
    ax.plot(N, fortrat, label='Fortran')
    
    ax.set_title('timeit(sqrt(a**2+b**2)) / timeit(hypot(a,b)) \n Numpy {} Python {} Gfortran {}'.format(np.__version__,pyver,fortver))
    ax.set_xscale('log')
    ax.legend(loc='best')
    ax.grid(True, which='both')
    ax.set_xlabel('N length of vectors a,b')


def benchmark_hypot_fortran(N, Nrun):
    fortrat = []
    for n in N:
        r = subprocess.check_output(['./bin/hypot', str(n), str(Nrun)], universal_newlines=True)
        fortrat.append(float(r.split(' ')[-1]))
        
    return fortrat


if __name__ == '__main__':
    Nrun = 3
    N = np.logspace(1,6.5,20,True,dtype=int)

   
    pyrat = bench_hypot(N, Nrun)
    fortrat = benchmark_hypot_fortran(N, Nrun)

    if figure is not None:
        plotspeed(N,pyrat,fortrat )
        show()
    else:
        print('Python')
        print(pyrat)
        
        print('Fortran')
        print(fortrat)
