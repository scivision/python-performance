#!/usr/bin/env python
import numba
import timeit
from numba import jit
import numpy as np
from argparse import ArgumentParser


@jit(nopython=True)
def pisum(N: int) -> float:
    """
    Machin formula for Pi http://mathworld.wolfram.com/PiFormulas.html
    """
    s = 0.0
    for k in range(1, N + 1):
        s += (-1) ** (k + 1) / (2 * k - 1)

    return 4.0 * s


def main():
    p = ArgumentParser(description="pisum benchmark")
    p.add_argument("N", nargs="?", default=1000000, type=int)
    p.add_argument("Nrun", nargs="?", default=10, type=int)
    p = p.parse_args()

    if not np.isclose(np.pi, pisum(p.N), rtol=1e-4):
        raise SystemExit("Numba convergence error")

    print("--> Numba {}".format(numba.__version__), "N=", p.N)
    t = timeit.repeat(
        "pisum({})".format(p.N),
        "import gc; gc.enable(); from __main__ import pisum",
        repeat=p.Nrun,
        number=1,
    )

    t = min(t)
    print("{:.3e} seconds.".format(t))


if __name__ == "__main__":
    main()
