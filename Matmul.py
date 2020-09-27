#!/usr/bin/env python
from pathlib import Path
from argparse import ArgumentParser
import typing as T
import shutil

import python_performance as pb

try:
    from matplotlib.pyplot import figure, show
except ImportError:
    figure = show = None

bdir = Path(__file__).parent / "matmul"
cdir = Path(__file__).parent / "build" / "matmul"


def main():

    p = ArgumentParser()
    p.add_argument("-N", type=int, default=1000)
    p.add_argument("-Nrun", type=int, default=10)
    p = p.parse_args()

    times = benchmark_matmul(p.N, p.Nrun)
    for k, v in times.items():
        print(k, v)

    if figure is not None and len(times) > 0:
        ax = figure().gca()
        ax.scatter(times.keys(), times.values())

        ax.set_title("Matmul, N={}".format(p.N))
        ax.set_ylabel("run time [sec.]")
        # ax.set_yscale('log')
        ax.grid(True)
        # ax.autoscale(True)  # bug?
        # ax.legend(loc='best')
        show()


def benchmark_matmul(N: int, Nrun: int) -> T.Dict[str, float]:
    times = {}
    compinf = pb.compiler_info()
    matmul_exe = shutil.which("matmul_fort", path=str(cdir))

    t = pb.run([matmul_exe, str(N), str(Nrun)], cdir, "fortran")
    if t is not None:
        times["Fortran\n" + compinf["fc"] + "\n" + compinf["fcvers"]] = t[0]

    t = pb.run(["julia", "matmul.jl", str(N)], bdir)
    if t is not None:
        times["julia \n" + t[1]] = t[0]

    t = pb.run(["gdl", "-q", "-e", "matmul", "-arg", str(N)], bdir)
    if t is not None:
        times["gdl \n" + t[1]] = t[0]

    t = pb.run(["idl", "-quiet", "-e", "matmul", "-arg", str(N)], bdir)
    if t is not None:
        times["idl \n" + t[1]] = t[0]

    # octave-cli, not octave in general
    t = pb.run(["octave-cli", "--eval", f"matmul({N},{Nrun})"], bdir)
    if t is not None:
        times["octave \n" + t[1]] = t[0]

    t = pb.run(["matlab", "-batch", f"matmul({N},{Nrun})"], bdir)
    if t is not None:
        times["matlab \n" + t[1]] = t[0]

    t = pb.run(["python", "matmul.py", str(N), str(Nrun)], bdir)
    if t is not None:
        times["python \n" + t[1]] = t[0]

    return times


# %%
if __name__ == "__main__":
    main()
