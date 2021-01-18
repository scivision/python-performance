#!/usr/bin/env python3

from pathlib import Path
from argparse import ArgumentParser
import typing as T
import shutil
import subprocess

import python_performance as pb

try:
    from matplotlib.pyplot import figure, show
except ImportError:
    figure = show = None


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

        ax.set_title(f"Matmul, N={p.N}")
        ax.set_ylabel("run time [sec.]")
        # ax.set_yscale('log')
        ax.grid(True)
        # ax.autoscale(True)  # bug?
        # ax.legend(loc='best')
        show()


def benchmark_matmul(N: int, Nrun: int) -> T.Dict[str, float]:
    times = {}
    compinf = pb.compiler_info()

    R = Path(__file__).parent
    Rs = R / "matmul"
    build_dir = R / "build"

    exe = shutil.which("matmul_fort", path=str(build_dir))
    if exe is None:
        subprocess.check_call(["cmake", f"-S{R}", f"-B{build_dir}"])
        subprocess.check_call(["cmake", "--build", str(build_dir)])
        exe = shutil.which("matmul_fort", path=build_dir)
        if not exe:
            return times

    t = pb.run([exe, str(N), str(Nrun)], build_dir, "fortran")
    if t is not None:
        times["Fortran\n" + compinf["fc"] + "\n" + compinf["fcvers"]] = t[0]

    t = pb.run(["julia", "matmul.jl", str(N)], Rs)
    if t is not None:
        times["julia \n" + t[1]] = t[0]

    t = pb.run(["gdl", "-q", "-e", "matmul", "-arg", str(N)], Rs)
    if t is not None:
        times["gdl \n" + t[1]] = t[0]

    t = pb.run(["idl", "-quiet", "-e", "matmul", "-arg", str(N)], Rs)
    if t is not None:
        times["idl \n" + t[1]] = t[0]

    # octave-cli, not octave in general
    t = pb.run(["octave-cli", "--eval", f"matmul({N},{Nrun})"], Rs)
    if t is not None:
        times["octave \n" + t[1]] = t[0]

    t = pb.run(["matlab", "-batch", f"matmul({N},{Nrun})"], Rs)
    if t is not None:
        times["matlab \n" + t[1]] = t[0]

    t = pb.run(["python", "matmul.py", str(N), str(Nrun)], Rs)
    if t is not None:
        times["python \n" + t[1]] = t[0]

    return times


if __name__ == "__main__":
    main()
