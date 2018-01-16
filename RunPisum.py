#!/usr/bin/env python
from pythonperformance import Path
from time import time
import subprocess as S
import logging
from six import PY2
if PY2:
    FileNotFoundError=OSError

bdir = Path('pisum')
#%% C
try:
    print('C -->')
    S.check_call(['./iterc'], cwd='bin')
except FileNotFoundError:
    logging.error('please compile pisum.c as per README')
    
#%% Fortran
try:
    print('Fortran -->')
    S.check_call(['./iterfort'], cwd='bin')
except FileNotFoundError:
    logging.error('please compile Pisum Fortran code as per README')


#%% Julia
try:
    print('Julia -->')
    S.check_call(['julia','iter.jl'], cwd=str(bdir))
except FileNotFoundError:
    logging.warning('Julia test skipped')
#%% GDL
try:
    print('GDL -->')
#    # baseline
#    tic = time()
#    S.check_call(['gdl','-q','-e','exit'])
#    base = time() - tic
#    # benchmark
#    tic = time()
    S.check_call(['gdl','-q','-e','pisum'],cwd=str(bdir))
#    toc = time() - tic 
#    t = toc - base
#    print('{:.2f} milliseconds'.format(t*1000))
except FileNotFoundError:
    logging.warning('GDL test skipped')

#%% Octave
try:
    print('Octave -->')
    S.check_call(['octave-cli','-q','iter.m'], cwd=str(bdir))
except FileNotFoundError:
    logging.warning('Octave test skipped')
    
#%% Matlab
try:
    print('Matlab -->')
    S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r',
           'iter; exit'], cwd=str(bdir))
except FileNotFoundError:
    logging.warning('Matlab test skipped')

#%% Python
try:
    print('Python -->')
    S.check_call(['ipython','pisum.ipy'],cwd=str(bdir))
except FileNotFoundError:
    logging.warning('Python test skipped')
