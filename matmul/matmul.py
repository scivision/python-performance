#!/usr/bin/env python
import platform
import timeit


def bench_matmul(N,Nrun):

    #A = np.matrix(np.random.randn(N,N))
    #B = np.matrix(np.random.randn(N,N))

    t = timeit.repeat('A@B',
           f'import gc; gc.enable();import numpy as np; A = np.array(np.random.randn({N},{N}));B = np.array(np.random.randn({N},{N}))',
           repeat=Nrun, number=1)

    return min(t)

if __name__ == '__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='Matmul benchmark')
    p.add_argument('N',nargs='?',default=1000,type=int)
    p.add_argument('Nrun',nargs='?',default=10,type=int)
    p = p.parse_args()


    print('--> Python {}'.format(platform.python_version()))

    t = bench_matmul(p.N, p.Nrun)

    print(f'{t:.6f} seconds for N={p.N}')