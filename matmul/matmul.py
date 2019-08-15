#!/usr/bin/env python
import platform
import timeit
import argparse

p = argparse.ArgumentParser(description="Matmul benchmark")
p.add_argument("N", nargs="?", default=1000, type=int)
p.add_argument("Nrun", nargs="?", default=10, type=int)
P = p.parse_args()

print("--> Python", platform.python_version())

N = P.N

t = timeit.repeat(
    "A @ B",
    (
        "import gc; gc.enable();import numpy as np;"
        f"A = np.array(np.random.randn({N},{N}));"
        f"B = np.array(np.random.randn({N},{N}));"
    ),
    repeat=P.Nrun,
    number=1,
)


print(f"{min(t):.6f} seconds for N", N)
