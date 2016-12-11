#!/usr/bin/env python
from __future__ import print_function
from pythonperformance import Path
from time import time
import subprocess as S
from six import PY2
if PY2:
    FileNotFoundError=OSError

bdir = Path('pisum')
#%% C
try:
    S.check_call(['./iterc'],cwd='bin')
except FileNotFoundError:
    pass
#%% Fortran
try:
    S.check_call(['./iterfort'],cwd='bin')
except FileNotFoundError:
    pass
#%% Julia
#try:
#    S.check_call(['julia',str(bdir/'iter.jl')])
#except FileNotFoundError:
#    pass
#%% GDL
try:
    # baseline
    tic = time()
    S.check_call(['gdl','-q','-e','exit'])
    base = time() - tic
    # benchmark
    tic = time()
    S.check_call(['gdl','-q','-e','pisum'],cwd=str(bdir))
    toc = time() - tic 
    t = toc - base
    print('--> GDL',end=' ')
    print('{:.2f} milliseconds'.format(t*1000))
except FileNotFoundError:
    pass

#%% Octave
try:
    S.check_call(['octave','-q','--eval','run iter.m'],cwd=str(bdir))
    print('TODO: Octave does not stdout for eval')
except FileNotFoundError:
    pass
#%% Matlab
try:
    S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r',
           'run iter.m' + '; exit'],cwd=str(bdir))
except FileNotFoundError:
    pass

#%% Python
try:
    S.run(['ipython','pisum.ipy'],cwd=str(bdir))
except FileNotFoundError:
    print('skip Python')
    pass
