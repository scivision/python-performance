#!/usr/bin/env python3
"""
Compare speed of hypot(x,y) vs. sqrt(x**2 + y**2)

hypot() is generally faster and more stable than sqrt()
"""

import subprocess
from pathlib import Path
import timeit
import sys
import shutil

import numpy as np

try:
    from matplotlib.pyplot import figure
except (ImportError, RuntimeError):
    figure = None

bdir = Path(__file__).parent
cdir = bdir / "build"


def main():
    Nrun = 3
    N = np.logspace(1, 6.5, 20, True, dtype=int)

    pyrat = bench_hypot(N, Nrun)
    fortrat = benchmark_hypot_fortran(N, Nrun)

    if figure is not None:
        plotspeed(N, pyrat, fortrat)
    else:
        print("Python", pyrat)
        print("Fortran", fortrat)


def bench_hypot(N, Nrun):
    pyrat = []

    for n in N:
        print("N=", n)
        thy = timeit.repeat(
            "np.hypot(a, b)",
            "import gc; gc.enable();import numpy as np; a = np.arange({},dtype=float); b = a.copy()".format(
                n
            ),
            repeat=Nrun,
            number=3 * Nrun,
        )

        tsq = timeit.repeat(
            "np.sqrt(a**2+b**2)",
            "import gc; gc.enable();import numpy as np; a = np.arange({},dtype=float); b = a.copy()".format(
                n
            ),
            repeat=Nrun,
            number=3 * Nrun,
        )

        pyrat.append(min(tsq) / min(thy))

    return pyrat


def plotspeed(N, pyrat, fortrat):
    pyver = sys.version_info
    pyver = "{}.{}.{}".format(pyver[0], pyver[1], pyver[2])

    fortver = (
        subprocess.check_output(["gfortran", "--version"], text=True).split("\n")[0].split(" ")[-1]
    )

    fg = figure()
    ax = fg.gca()

    ax.plot(N, pyrat, label="Python")
    if fortrat is not None:
        ax.plot(N, fortrat, label="Fortran")

    ax.set_title(
        "timeit(sqrt(a**2+b**2)) / timeit(hypot(a,b)) \n Numpy {} Python {} Gfortran {}".format(
            np.__version__, pyver, fortver
        )
    )
    ax.set_xscale("log")
    ax.legend(loc="best")
    ax.grid(True, which="both")
    ax.set_xlabel("N length of vectors a,b")

    figfn = bdir / "hypot.png"
    print("saved figure to", figfn)
    fg.savefig(figfn)


def benchmark_hypot_fortran(N, Nrun):
    fortrat = []
    exe = shutil.which("hypot", path=cdir)

    for n in N:
        r = subprocess.check_output([exe, str(n), str(Nrun)], text=True)
        fortrat.append(float(r.split(" ")[-1]))

    return fortrat


if __name__ == "__main__":
    main()
