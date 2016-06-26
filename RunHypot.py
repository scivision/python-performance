#!/usr/bin/env python
"""
Compare speed of hypot(x,y) vs. sqrt(x**2 + y**2)
hypot() is faster for small arrays, but gets a little slower for large arrays.
Breakpoint around 10**5 elements on my PC.
"""
import subprocess
import numpy as np
from matplotlib.pyplot import figure,show
from timeit import repeat
import sys
import seaborn as sns
sns.set_context('talk')

# this must NOT be as function for a,b to work properly.
N = np.logspace(1,6.5,25,True,dtype=int)
print('N={}'.format(N))
rat = np.empty(N.size)

for i,n in enumerate(N):
    a = np.arange(n,dtype=float)
    b = np.arange(n,dtype=float)
    rep=N[-(i+1)]
    print('N={}  count {}'.format(n,rep))
    thy=repeat('np.hypot(a, b)',
               'import gc; gc.enable();import numpy as np; from __main__ import a,b',
               repeat=5,number=rep)

    tsq=repeat('np.sqrt(a**2+b**2)',
               'import gc; gc.enable();import numpy as np; from __main__ import a,b',
                repeat=5,number=rep)
    rat[i]=min(tsq) / min(thy)

pyver = sys.version_info
pyver = '{}.{}.{}'.format(pyver[0],pyver[1],pyver[2])

ax = figure().gca()
ax.plot(N,rat)
ax.set_title('timeit(sqrt(a**2+b**2)) / timeit(hypot(a,b)) \n Numpy {} Python {}'.format(np.__version__,pyver))
ax.set_xscale('log')
ax.legend(loc='best')
ax.grid(True,which='both')
ax.set_xlabel('N length of vectors a,b')
show()

def benchmark_hypot_fortran():
    subprocess.call(['./bin/hypot'])


if __name__ == '__main__':
    benchmark_hypot_fortran()