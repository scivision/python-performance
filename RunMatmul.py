#!/usr/bin/env python
from time import time
import logging
import subprocess as S
from six import PY2
if PY2:
    FileNotFoundError=OSError
#%% Fortran
try:
    print ('Fortran -->')
    S.call(['./bin/matmul'])
except FileNotFoundError:
    logging.error('Fortran test skipped')
    
#%% Julia
try:
    print('Julia -->')
    S.check_call(['julia','matmul.jl'])
except FileNotFoundError:
    logging.error('Julia test skipped')
    
#%% GDL
try:
    print('GDL -->')
    tic = time()
    S.check_call(['gdl','-q','matmul.pro'])
    S.check_call(['gdl','-v'])
    print('{:.2f} seconds'.format(time()-tic))
except FileNotFoundError:
    logging.error('GDL test skipped')
    
#%% Octave
try:
    print('Octave -->')
    S.check_call(['octave-cli','-q','matmul.m'])
except FileNotFoundError:
    logging.error('Octave test skipped')
    
#%% Matlab
try:
    print('Matlab -->')
    S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r','run matmul.m; exit'])
except FileNotFoundError:
    logging.error('Matlab test skipped')
    
#%% Python 2.7
try:
    print('Python 2 -->')
    S.check_call(['ipython2','matmul.ipy'])
except FileNotFoundError:
    logging.error('Python2 test skipped')
#%% Python 3
try:
    print('Python 3 -->')
    S.check_call(['ipython3','matmul.ipy'])
except FileNotFoundError:
    logging.error('Python3 test skipped')
