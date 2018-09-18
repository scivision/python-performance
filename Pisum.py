#!/usr/bin/env python
from pythonperformance import Path
import logging
import subprocess as S
from six import PY2
import os
from argparse import ArgumentParser
if PY2:
    FileNotFoundError = OSError

bdir = 'pisum'


def main():

    p = ArgumentParser()
    p.add_argument('-N', type=int, default=1000000)
    p.add_argument('-Nrun', type=int, default=10)
    p = p.parse_args()

    test_pisum(p.N, p.Nrun)


def test_pisum(N, Nrun):

    cexe = './pisumc'
    fexe = './pisumfort'
    if os.name == 'nt':
        cexe = cexe[2:]
        fexe = fexe[2:]
    # %% C
    try:
        print()
        S.check_call([cexe, str(N)], cwd='bin/'+bdir)
    except FileNotFoundError:
        logging.error('please compile pisum.c as per README')

    # %% Fortran
    try:
        print()
        S.check_call([fexe, str(N), str(Nrun)], cwd='bin/'+bdir)
    except FileNotFoundError:
        logging.error('please compile Pisum Fortran code as per README')

    # %% Julia
    try:
        print()
        S.check_call(['julia', 'pisum.jl', str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Julia executable not found')

    # %% GDL
    try:
        print('\n --> GDL')
        S.check_call(['gdl', '--version'])

        S.check_call(['gdl', '-q', '-e', 'pisum', '-arg', str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('GDL executable not found')

    # %% IDL
    try:
        print('\n --> IDL')

        S.check_call(['idl', '-e', 'pisum', '-arg', str(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('IDL executable not found')

    # %% Octave
    try:
        print()
        S.check_call(['octave-cli', '-q', '--eval', 'pisum({})'.format(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Octave executable not found')

    # %% Matlab
    try:
        print()
        S.check_call(['matlab', '-nodesktop', '-nojvm', '-nosplash', '-r',
                      'pisum({}); exit'.format(N)], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Matlab executable not found')

    # %% Python
    try:
        print()
        S.check_call(['python', 'pisum.py'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Python test skipped')


# %%
if __name__ == '__main__':
    main()
