#!/usr/bin/env python
from numpy.random import rand
import accelerate.cuda as cuda
from accelerate.cuda.blas import Blas
# for testing
import numba.cuda.api,numba.cuda.cudadrv.libs
import numpy as np
from timeit import default_timer as timer

def gemm(A,B,dD):
    N=A.shape[0] #square matrices
    '''
    Note that all arrays are in Fortran order.
    '''

    # cuBLAS
    blas = Blas()

    start = timer()
    blas.gemm('N', 'N', N, N, N, 1.0, A, B, 1.0, dD)
    cuda_time = timer() - start

    D = dD.copy_to_host()
    print("CUBLAS took %f seconds" % cuda_time)
    diff = np.abs(D - E)
    print("Maximum error %f" % np.max(diff))
    return D

def test_pycuda():
    numba.cuda.cudadrv.libs.test()
    assert numba.cuda.api.detect(),'https://scivision.co/install-cuda-accelerate-for-anaconda-python/'

if __name__ == '__main__':
    test_pycuda() # not necessary, just FYI

    N=1000
    Nrun = 10

    A= np.asfortranarray(rand(N,N).astype(np.float32))
    B= np.asfortranarray(rand(N,N).astype(np.float32))
    D = np.asfortranarray(np.zeros_like(A,order='F'))

    s = timer()
    dA = cuda.cuda.to_device(A)             # alloc and copy input data
    dB = cuda.cuda.to_device(B)
    dD = cuda.cuda.to_device(D, copy=False) # alloc only
    print(timer() -s)
    # NumPy
    numpy_time=1000000
    for _ in range(Nrun):
        start = timer()
        E = A.dot(B)
        T = timer() - start
        if T<numpy_time: numpy_time = T
    print("Numpy  took %f seconds" % numpy_time)

    gemm(dA,dB,dD)
