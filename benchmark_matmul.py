from numpy.random import rand
from numbapro import guvectorize

import numba
print('numba {}'.format(numba.__version__))

@guvectorize(['void(float64[:,:], float64[:,:], float64[:,:])'],
             '(m,n),(n,p)->(m,p)',
             target='gpu')
def matmul(A, B, C):
    m, n = A.shape
    n, p = B.shape
    for i in range(m):
        for j in range(p):
            C[i, j] = 0
            for k in range(n):
                C[i, j] += A[i, k] * B[k, j]
 
if __name__ == '__main__':
 
    A=rand(5000,5000)
    B=rand(5000,5000) 
    
    C=matmul(A,B)
    
    #%timeit f(A)
