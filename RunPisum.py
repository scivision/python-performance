#!/usr/bin/env python
from __future__ import print_function
from time import time
import logging
import subprocess as S
from six import PY2

if PY2:
    FileNotFoundError=OSError

bdir = 'pisum'

def test_pisum(juliapath=''):

    #%% C
    try:
        print()
        S.check_call(['./iterc'], cwd='bin')
    except FileNotFoundError:
        logging.error('please compile pisum.c as per README')
        
    #%% Fortran
    try:
        print()
        S.check_call(['./iterfort'], cwd='bin')
    except FileNotFoundError:
        logging.error('please compile Pisum Fortran code as per README')


    #%% Julia
    try:
        print()
        S.check_call([juliapath+'julia','iter.jl'], cwd=bdir) 
    except FileNotFoundError:
        logging.warning('Julia executable not found')


    #%% GDL
    try:
        print('\n --> GDL')
        S.check_call(['gdl','--version'])

        S.check_call(['gdl','-q','-e','pisum'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('GDL executable not found')

    #%% IDL
    try:
        print('\n --> IDL')
        S.check_call(['idl','--version'])

        S.check_call(['idl','-q','-e','pisum'],cwd=bdir)
    except FileNotFoundError:
        logging.warning('IDL executable not found')

    #%% Octave
    try:
        print()
        S.check_call(['octave-cli','-q','iter.m'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Octave executable not found')
        
    #%% Matlab
    try:
        print()
        S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r',
               'iter; exit'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Matlab executable not found')

    #%% Python
    try:
        print()
        S.check_call(['ipython','pisum.ipy'],cwd=bdir)
    except FileNotFoundError:
        logging.warning('Python test skipped')


# %%
from argparse import ArgumentParser
p = ArgumentParser()
p.add_argument('juliapath',help='path to julia executable',nargs='?',default='')
p = p.parse_args()

test_pisum(p.juliapath)
