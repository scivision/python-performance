#!/usr/bin/env python
from pathlib import Path
from argparse import ArgumentParser
import typing as T
import math
import platform
import shutil
import numpy as np

import python_performance as pb

try:
    from matplotlib.pyplot import figure, show
except ImportError:
    figure = show = None

bdir = Path(__file__).parent / "pisum"
cdir = Path(__file__).parent / "build" / "pisum"


def main():

    p = ArgumentParser()
    p.add_argument("-N", type=int, default=[10001, 100001, 1000001], nargs="+")
    p.add_argument("-Nrun", type=int, default=10)
    p = p.parse_args()

    times = {}
    for N in p.N:
        print("\nN=", N)
        print("----------------")
        t = benchmark_pisum(N, p.Nrun)
        t = {k: v for k, v in t.items() if math.isfinite(v)}
        times[N] = dict(sorted(t.items(), key=lambda x: x[1]))

        for k, v in t.items():
            print(k, v)

    if figure is not None and len(t) > 0:
        ax = figure().gca()
        for k, v in times.items():
            ax.scatter(v.keys(), v.values(), label=str(k))

        ax.set_title(f"PiSum, N={p.N}   {platform.system()}")
        ax.set_ylabel("run time [sec.]")
        ax.set_yscale("log")
        ax.grid(True)
        # ax.autoscale(True)  # bug?
        # leave nanmin/nanmax for where some iterations fail
        # list() is necessary as numpy.nanmin doesn't like the dict.values() generator
        ax.set_ylim(
            (
                max(1e-6, 0.1 * np.nanmin(list(times[min(p.N)].values()))),
                10 * np.nanmax(list(times[max(p.N)].values())),
            )
        )
        ax.legend(loc="best")
        show()


def benchmark_pisum(N, Nrun, paths: T.Dict[str, Path] = None) -> T.Dict[str, float]:
    times = {}
    compinf = pb.compiler_info()

    exe = shutil.which("pisumc", path=cdir)
    t = pb.run([exe, str(N), str(Nrun)], cdir, "c")
    if t is not None:
        times["C\n" + compinf["cc"] + "\n" + compinf["ccvers"]] = t[0]

    exe = shutil.which("pisumfort", path=cdir)
    t = pb.run([exe, str(N), str(Nrun)], cdir, "fortran")
    if t is not None:
        times["Fortran\n" + compinf["fc"] + "\n" + compinf["fcvers"]] = t[0]

    t = pb.run(["julia", "pisum.jl", str(N)], bdir)
    if t is not None:
        times["julia \n" + t[1]] = t[0]

    t = pb.run(["gdl", "-q", "-e", "pisum", "-arg", str(N)], bdir)
    if t is not None:
        times["gdl \n" + t[1]] = t[0]

    t = pb.run(["idl", "-quiet", "-e", "pisum", "-arg", str(N)], bdir)
    if t is not None:
        times["idl \n" + t[1]] = t[0]

    # octave-cli, not octave in general
    t = pb.run(["octave-cli", "--eval", f"pisum({N},{Nrun})"], bdir)
    if t is not None:
        times["octave \n" + t[1]] = t[0]

    t = pb.run(["matlab", "-batch", "pisum({},{}); exit".format(N, Nrun)], bdir)
    if t is not None:
        times["matlab \n" + t[1]] = t[0]

    t = pb.run(["python", "pisum.py", str(N), str(Nrun)], bdir)
    if t is not None:
        times["python \n" + t[1]] = t[0]

    t = pb.run(["pypy3", "pisum.py", str(N), str(Nrun)], bdir)
    if t is not None:
        times["pypy \n" + t[1]] = t[0]

    t = pb.run(["python", "pisum_cython.py", str(N), str(Nrun)], bdir)
    if t is not None:
        times["cython \n" + t[1]] = t[0]

    t = pb.run(["python", "pisum_numba.py", str(N), str(Nrun)], bdir)
    if t is not None:
        times["numba \n" + t[1]] = t[0]

    return times


if __name__ == "__main__":
    main()
