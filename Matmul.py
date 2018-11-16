#!/usr/bin/env python
from pathlib import Path
import subprocess
from argparse import ArgumentParser
import pythonperformance as pb
from typing import Dict
try:
    from matplotlib.pyplot import figure, show
except ImportError:
    figure = show = None

bdir = Path(__file__).parent / 'matmul'
cdir = Path(__file__).parent / 'bin' / 'matmul'


def main():

    p = ArgumentParser()
    p.add_argument('-N', type=int, default=1000)
    p.add_argument('-Nrun', type=int, default=10)
    p = p.parse_args()

    times = benchmark_matmul(p.N, p.Nrun)
    print(times)

    if figure is not None and len(times) > 0:
        ax = figure().gca()
        ax.scatter(times.keys(), times.values())

        ax.set_title('PiSum, N={}'.format(p.N))
        ax.set_ylabel('run time [sec.]')
        # ax.set_yscale('log')
        ax.grid(True)
        # ax.autoscale(True)  # bug?
        # ax.legend(loc='best')
        show()


def benchmark_matmul(N: int, Nrun: int) -> Dict[str, float]:
    times = {}
    compinf = pb.compiler_info()
# %% Fortran
    t = pb.run(['./matmul', str(N), str(Nrun)], cdir, 'fortran')
    if t is not None:
        times['Fortran\n'+compinf['fc']+'\n'+compinf['fcvers']] = t[0]  # type: ignore

# %% Julia
    t = pb.run(['julia', 'matmul.jl', str(N)], bdir)
    if t is not None:
        times['julia \n'+t[1]] = t[0]
# %% GDL
    try:
        vers = subprocess.check_output(['gdl', '--version'], universal_newlines=True).split()[-2]
        t = pb.run(['gdl', '-q', '-e', 'matmul', '-arg', str(N), '--fakerelease', vers], bdir)
        if t is not None:
            times['gdl \n'+t[1]] = t[0]
    except FileNotFoundError:
        pass
# %% IDL
    t = pb.run(['idl', '-quiet', '-e', 'matmul', '-arg', str(N)], bdir)
    if t is not None:
        times['idl \n'+t[1]] = t[0]
# %% Octave
    t = pb.run(['octave', '-q', '--eval', 'matmul({},{})'.format(N, Nrun)], bdir)
    if t is not None:
        times['octave \n'+t[1]] = t[0]
# %% Matlab
    t = pb.run(['matlab', '-nodesktop', '-nojvm', '-nosplash', '-r', 'matmul({},{}); exit'.format(N, Nrun)], bdir)
    if t is not None:
        times['matlab \n'+t[1]] = t[0]
    # %% Python
    t = pb.run(['python', 'matmul.py', str(N), str(Nrun)], bdir)
    if t is not None:
        times['python \n'+t[1]] = t[0]

    return times


# %%
if __name__ == '__main__':
    main()
