#!/usr/bin/env python
from pathlib import Path
import logging
import subprocess
from six import PY2
import os
from argparse import ArgumentParser
if PY2:
    FileNotFoundError = OSError


bdir = 'matmul'


def main():

    p = ArgumentParser()
    p.add_argument('-N', type=int, default=1000)
    p.add_argument('-Nrun', type=int, default=10)
    p = p.parse_args()

    test_matmul(p.N, p.Nrun)


def test_matmul(N, Nrun):
    # %% Fortran
    try:
        print('Fortran -->')
        exe = './matmul'
        if os.name == 'nt':
            exe = exe[2:]
        subprocess.call([exe, str(N), str(Nrun)],
                        cwd=str(Path('bin')/bdir))
    except FileNotFoundError:
        logging.error('Fortran test skipped')

    # %% Julia
    try:
        print()
        subprocess.check_call(['julia', 'matmul.jl', str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Julia executable not found')

    # %% GDL
    try:
        print('\n --> GDL')
        subprocess.check_call(['gdl', '--version'])

        subprocess.check_call(
            ['gdl', '-q', '-e', 'matmul', '-arg', str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('GDL executable not found')

    # %% IDL
    try:
        print('\n --> IDL')

        subprocess.check_call(
            ['idl', '-e', 'matmul', '-arg', str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('IDL executable not found')

    # %% Octave
    try:
        print()
        subprocess.check_call(
            ['octave-cli', '-q', '--eval', 'matmul({})'.format(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Octave executable not found')

    # %% Matlab
    try:
        print()
        subprocess.check_call(['matlab', '-nodesktop', '-nojvm',
                               '-nosplash', '-r', 'matmul({}); exit'.format(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Matlab executable not found')

    # %% Python
    try:
        print()
        subprocess.check_call(
            ['python', 'matmul.py', str(N), str(Nrun)], cwd=bdir)
    except FileNotFoundError:
        logging.error('Python test skipped')


# %%
if __name__ == '__main__':
    main()
