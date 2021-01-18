#!/usr/bin/env python
import math
from argparse import ArgumentParser
import timeit
import cython

#
import pyximport

pyximport.install()
import cpisum  # noqa: E402


def main():
    p = ArgumentParser(description="pisum benchmark")
    p.add_argument("N", nargs="?", default=1000000, type=int)
    p.add_argument("Nrun", nargs="?", default=10, type=int)
    p = p.parse_args()

    if not math.isclose(math.pi, cpisum.pisum(p.N), rel_tol=1e-4):
        raise SystemExit("Cython convergence error")

    print("--> Cython ", cython.__version__, "N=", p.N)

    t = timeit.repeat(
        "cpisum.pisum({})".format(p.N),
        "import gc; gc.enable(); import cpisum",
        repeat=p.Nrun,
        number=1,
    )

    t = min(t)
    print("{:.3e} seconds.".format(t))


if __name__ == "__main__":
    main()
