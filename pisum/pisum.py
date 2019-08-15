#!/usr/bin/env python
import platform
import timeit
from argparse import ArgumentParser
import math


def pisum_c(N: int) -> float:
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

    assert math.isclose(
        math.pi, pisum_c(p.N), rel_tol=1e-4
    ), "CPython convergence error"

    print("--> Python", platform.python_version(), "N=", p.N)
    t = timeit.repeat(
        "pisum_c({})".format(p.N),
        "import gc; gc.enable(); from __main__ import pisum_c",
        repeat=p.Nrun,
        number=1,
    )

    t = min(t)
    print("{:.3e} seconds.".format(t))


if __name__ == "__main__":
    main()
