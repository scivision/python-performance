#!/usr/bin/env python
from __future__ import print_function
from pythonperformance import Path
from time import time
import subprocess as S
from sys import stderr
from six import PY2
if PY2:
    FileNotFoundError=OSError

bdir = Path('pisum')
#%% C
try:
    S.check_call(['./iterc'],cwd='bin')
except FileNotFoundError:
    print('please compile pisum.c as per README',file=stderr)
    pass
#%% Fortran
try:
    S.check_call(['./iterfort'],cwd='bin')
except FileNotFoundError:
    print('please compile Pisum Fortran code as per README',file=stderr)
    pass
#%% Julia
try:
    S.check_call(['julia','iter.jl'],cwd=str(bdir))
except FileNotFoundError:
    pass
#%% GDL
try:
    print('--> GDL',end=' ')
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
    pass

#%% Octave
try:
    S.check_call(['octave','-q','--eval','iter;exit'], cwd=str(bdir))
except FileNotFoundError:
    pass
#%% Matlab
try:
    S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r',
           'iter; exit'], cwd=str(bdir))
except FileNotFoundError:
    pass

#%% Python
try:
    S.run(['ipython','pisum.ipy'],cwd=str(bdir))
except FileNotFoundError:
    print('skip Python',file=stderr)
    pass
