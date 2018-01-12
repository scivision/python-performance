#!/usr/bin/env python
from time import time
import subprocess as S
from six import PY2
if PY2:
    FileNotFoundError=OSError
#%% Fortran
try:
    S.call(['./bin/matmul'])
except FileNotFoundError:
    pass
#%% Julia
try:
    S.check_call(['julia','matmul.jl'])
except FileNotFoundError:
    pass
#%% GDL
try:
    tic = time()
    S.check_call(['gdl','-q','matmul.pro'])
    S.check_call(['gdl','-v'])
    print('{:.2f} seconds'.format(time()-tic))
except FileNotFoundError:
    pass
#%% Octave
try:
    S.check_call(['octave','-q','--eval','run matmul.m'])
except FileNotFoundError:
    pass
#%% Matlab
try:
    S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r','run matmul.m; exit'])
except FileNotFoundError:
    pass
#%% Python 2.7
try:
    S.check_call(['ipython2','matmul.ipy'])
except FileNotFoundError:
    pass
#%% Python 3
try:
    S.check_call(['ipython3','matmul.ipy'])
except FileNotFoundError:
    pass
