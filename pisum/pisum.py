#!/usr/bin/env python
import pyximport; pyximport.install()
from numba import jit # inline auto compilation to C of Python code
import numba,numpy,math
import platform
import timeit
import cython
#
import cpisum

N=1000000
Nrun=3

@jit(nopython=True)
def pisum():
    """
    Machin formula for Pi http://mathworld.wolfram.com/PiFormulas.html
    """
    s = 0.
    for k in range(1, N+1):
        s += (-1)**(k+1)/(2*k-1)
    return 4.*s


def pisum_c():
    """
    Machin formula for Pi http://mathworld.wolfram.com/PiFormulas.html
    """
    s = 0.
    for k in range(1, N+1):
        s += (-1)**(k+1)/(2*k-1)
    return 4.*s


if __name__ == '__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='pisum benchmark')
    p.add_argument('N',nargs='?',default=1000000,type=int)
    p.add_argument('Nrun',nargs='?',default=10,type=int)
    p = p.parse_args()

# %% Numba
    assert numpy.isclose(numpy.pi,pisum(),rtol=1e-4)

    print('--> Numba {}'.format(numba.__version__))
    t = timeit.repeat('pisum()',
               'import gc; gc.enable(); from __main__ import pisum',
               repeat=Nrun, number=1)

    t = min(t)
    print(f'{t:.3e} seconds.')
# %%  PURE PYTHON
    print('--> Python {}'.format(platform.python_version()))
    t = timeit.repeat('pisum_c()',
               'import gc; gc.enable(); from __main__ import pisum_c',
               repeat=Nrun, number=1)

    t = min(t)
    print(f'{t:.3e} seconds.')
    
# %% CYTHON
    assert math.isclose(math.pi,cpisum.pisum(N),rel_tol=1e-4),'Cython convergence error'

    print('--> Cython ',cython.__version__)

    t = timeit.repeat(f'cpisum.pisum({N})',
               'import gc; gc.enable(); import cpisum',
               repeat=Nrun, number=1)

    t = min(t)
    print(f'{t:.3e} seconds.')