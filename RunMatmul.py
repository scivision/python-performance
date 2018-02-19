#!/usr/bin/env python
from __future__ import print_function
from time import time
import logging
import subprocess as S
from six import PY2

if PY2:
    FileNotFoundError=OSError


bdir='matmul'

def test_matmul(juliapath):

    #%% Fortran
    try:
        print ('Fortran -->')
        S.call(['./bin/matmul'])
    except FileNotFoundError:
        logging.error('Fortran test skipped')
        
    #%% Julia
    try:
        print('Julia -->')
        S.check_call([juliapath+'julia','matmul.jl'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Julia executable not found')


    #%% GDL
    try:
        print('\n --> GDL')
        S.check_call(['gdl','--version'])

        S.check_call(['gdl','-q','-e','matmul'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('GDL executable not found')

    #%% IDL
    try:
        print('\n --> IDL')
        S.check_call(['idl','--version'])

        S.check_call(['idl','-q','-e','matmul'],cwd=bdir)
    except FileNotFoundError:
        logging.warning('IDL executable not found')

    #%% Octave
    try:
        print()
        S.check_call(['octave-cli','-q','matmul.m'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Octave executable not found')
        
    #%% Matlab
    try:
        print()
        S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r','matmul; exit'], cwd=bdir)
    except FileNotFoundError:
        logging.warning('Matlab executable not found')
        

    #%% Python
    try:
        print()
        S.check_call(['ipython','matmul.ipy'], cwd=bdir)
    except FileNotFoundError:
        logging.error('Python test skipped')


# %%
from argparse import ArgumentParser
p = ArgumentParser()
p.add_argument('juliapath',help='path to julia executable',nargs='?',default='')
p = p.parse_args()

test_matmul(p.juliapath)
