#!/usr/bin/env python
from pathlib import Path
import pythonperformance as pb
import numpy as np
from argparse import ArgumentParser
from typing import Dict
import math
import subprocess
try:
    from matplotlib.pyplot import figure, show
except ImportError:
    figure = show = None

bdir = Path(__file__).parent / 'pisum'
cdir = Path(__file__).parent / 'bin' / 'pisum'


def main():

    p = ArgumentParser()
    p.add_argument('-N', type=int, default=[10001, 100001, 1000001], nargs='+')
    p.add_argument('-Nrun', type=int, default=10)
    p = p.parse_args()

    times = {}
    for N in p.N:
        print('\nN=', N)
        print('----------------')
        t = benchmark_pisum(N, p.Nrun)
        t = {k: v for k, v in t.items() if math.isfinite(v)}
        times[N] = dict(sorted(t.items(), key=lambda x: x[1]))  # Python >= 3.5

        print(t)

    if figure is not None and len(t) > 0:
        ax = figure().gca()
        for k, v in times.items():
            ax.scatter(v.keys(), v.values(), label=str(k))

        ax.set_title('PiSum, N={}'.format(p.N))
        ax.set_ylabel('run time [sec.]')
        ax.set_yscale('log')
        ax.grid(True)
        # ax.autoscale(True)  # bug?
        # leave nanmin/nanmax for where some iterations fail
        ax.set_ylim((0.1*np.nanmin(list(times[min(p.N)].values())),
                     10*np.nanmax(list(times[max(p.N)].values()))))
        ax.legend(loc='best')
        show()


def benchmark_pisum(N, Nrun, paths: Dict[str, Path] = None) -> Dict[str, float]:

    times = {}

    compinf = pb.compiler_info()

    t = pb.run(['./pisumc', str(N), str(Nrun)], cdir, 'c')
    if t is not None:
        times['C\n'+compinf['cc']+'\n'+compinf['ccvers']] = t[0]

    t = pb.run(['./pisumfort', str(N), str(Nrun)], cdir, 'fortran')
    if t is not None:
        times['Fortran\n'+compinf['fc']+'\n'+compinf['fcvers']] = t[0]

    t = pb.run(['julia', 'pisum.jl', str(N)], bdir)
    if t is not None:
        times['julia \n'+t[1]] = t[0]

    vers = subprocess.check_output(['gdl', '--version'], universal_newlines=True).split()[-2]
    t = pb.run(['gdl', '-q', '-e', 'pisum', '-arg', str(N), '--fakerelease', vers], bdir)
    if t is not None:
        times['gdl \n'+t[1]] = t[0]

    t = pb.run(['idl', '-quiet', '-e', 'pisum', '-arg', str(N)], bdir)
    if t is not None:
        times['idl \n'+t[1]] = t[0]

    t = pb.run(['octave', '-q', '--eval', 'pisum({},{})'.format(N, Nrun)], bdir)
    if t is not None:
        times['octave \n'+t[1]] = t[0]

    t = pb.run(['matlab', '-nodesktop', '-nojvm', '-nosplash', '-r', 'pisum({}); exit'.format(N)], bdir)
    if t is not None:
        times['matlab \n'+t[1]] = t[0]

    t = pb.run(['python', 'pisum.py', str(N), str(Nrun)], bdir)
    if t is not None:
        times['python \n'+t[1]] = t[0]

    t = pb.run(['pypy3', 'pisum.py', str(N), str(Nrun)], bdir)
    if t is not None:
        times['pypy \n'+t[1]] = t[0]

    t = pb.run(['python', 'pisum_cython.py', str(N), str(Nrun)], bdir)
    if t is not None:
        times['cython \n'+t[1]] = t[0]

    t = pb.run(['python', 'pisum_numba.py', str(N), str(Nrun)], bdir)
    if t is not None:
        times['numba \n'+t[1]] = t[0]

    return times


# %%
if __name__ == '__main__':
    main()
