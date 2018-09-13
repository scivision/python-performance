from __future__ import division
import cython

@cython.boundscheck(False)
@cython.wraparound(False)
def pisum(int N):
    """
    Machin formula for Pi http://mathworld.wolfram.com/PiFormulas.html
    """
    cdef float s
    cdef int k
    s = 0.
    for k in range(1, N+1):
        s += (-1)**(k+1) / (2*k-1)
    return 4.*s

