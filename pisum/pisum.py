#!/usr/bin/env python
import numpy
import math
import platform
import timeit
try:
    import cython
    import pyximport
    pyximport.install()
    import cpisum  # noqa: E402
except ImportError:
    cython = None
#
try:
    import numba
    from numba import jit
except ImportError:
    numba = None


N = 1000000
Nrun = 3

if numba is not None:
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
    p.add_argument('N', nargs='?', default=1000000, type=int)
    p.add_argument('Nrun', nargs='?', default=10, type=int)
    p = p.parse_args()


# %% Numba
    if numba is not None:
        assert numpy.isclose(numpy.pi, pisum(), rtol=1e-4)

        print('--> Numba {}'.format(numba.__version__))
        t = timeit.repeat('pisum()',
                          'import gc; gc.enable(); from __main__ import pisum',
                          repeat=Nrun, number=1)

        t = min(t)
        print('{:.3e} seconds.'.format(t))
# %%  PURE PYTHON
    print('--> Python {}'.format(platform.python_version()))
    t = timeit.repeat('pisum_c()',
                      'import gc; gc.enable(); from __main__ import pisum_c',
                      repeat=Nrun, number=1)

    t = min(t)
    print('{:.3e} seconds.'.format(t))

# %% CYTHON
    if cython is not None:
        assert math.isclose(math.pi, cpisum.pisum(N), rel_tol=1e-4), 'Cython convergence error'

        print('--> Cython ', cython.__version__)

        t = timeit.repeat('cpisum.pisum({})'.format(N),
                          'import gc; gc.enable(); import cpisum',
                          repeat=Nrun, number=1)

        t = min(t)
        print('{:.3e} seconds.'.format(t))

