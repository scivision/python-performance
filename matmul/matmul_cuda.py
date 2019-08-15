#!/usr/bin/env python
"""
Benchmark Numpy matrix multiplication
"""
import timeit
import argparse

p = argparse.ArgumentParser()
p.add_argument("N", nargs="?", default=1000, type=int)
p.add_argument("Nrun", nargs="?", default=10, type=int)
P = p.parse_args()

N = P.N
t = timeit.repeat(
    "A @ B",
    (
        "import gc; gc.enable();import cupy;"
        f"A = cupy.random.rand({N}, {N}, dtype=cupy.float32);"
        f"B = cupy.random.rand({N}, {N}, dtype=cupy.float32);"
    ),
    repeat=P.Nrun,
    number=1,
)

print(f"GPU matmul in {min(t):.3e} seconds")
