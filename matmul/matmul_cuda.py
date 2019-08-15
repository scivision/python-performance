#!/usr/bin/env python
import cupy
from timeit import default_timer as timer


if __name__ == '__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='Matmul benchmark')
    p.add_argument('N', nargs='?', default=1000, type=int)
    p.add_argument('Nrun', nargs='?', default=10, type=int)
    p = p.parse_args()

    N = p.N
    Nrun = p.Nrun

    s = timer()
    A = cupy.random.rand(N, N, dtype=cupy.float32)
    B = cupy.random.rand(N, N, dtype=cupy.float32)
    print(f'GPU allocated {N} x {N} array in {timer() - s:.3f} seconds.')

    s = timer()
    D = A @ B

    print(f'GPU matmul in {timer() - s:.3f} seconds')
