#!/usr/bin/env python
from time import time
import subprocess as S
from six import PY2
if PY2:
    FileNotFoundError=OSError
#%% Fortran
try:
    S.run(['./bin/matmul'])
except FileNotFoundError:
    pass
#%% Julia
try:
    S.run(['julia','matmul.jl'])
except FileNotFoundError:
    pass
#%% GDL
try:
    tic = time()
    S.run(['gdl','-q','matmul.pro'])
    S.run(['gdl','-v'])
    print('{:.2f} seconds'.format(time()-tic))
except FileNotFoundError:
    pass
#%% Octave
try:
    S.run(['octave','-q','--eval','run matmul.m'])
except FileNotFoundError:
    pass
#%% Matlab
try:
    S.run(['matlab','-nodesktop','-nojvm','-nosplash','-r','run matmul.m; exit'])
except FileNotFoundError:
    pass
#%% Python 2.7
try:
    S.run(['ipython2','matmul.ipy'])
except FileNotFoundError:
    pass
#%% Python 3
try:
    S.run(['ipython3','matmul.ipy'])
except FileNotFoundError:
    pass