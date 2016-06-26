#!/usr/bin/env python
from time import time
import subprocess as S
from six import PY2
if PY2:
    FileNotFoundError=OSError
#%% Fortran
try:
    S.run(['./bin/iter'])
except FileNotFoundError:
    pass
#%% Julia
try:
    S.run(['julia','iter.jl'])
except FileNotFoundError:
    pass
#%% GDL
try:
    tic = time()
    S.run(['gdl','-q','iter.pro'])
    S.run(['gdl','-v'])
    print('{:.2f} seconds'.format(time()-tic))
except FileNotFoundError:
    pass
#%% Octave
try:
    S.run(['octave','-q','--eval','run iter.m'])
except FileNotFoundError:
    pass
#%% Matlab
try:
    S.run(['matlab','-nodesktop','-nojvm','-nosplash','-r','run iter.m; exit'])
except FileNotFoundError:
    pass
#%% Python 2.7
try:
    S.run(['ipython2','iter.ipy'])
except FileNotFoundError:
    pass
#%% Python 3
try:
    S.run(['ipython3','iter.ipy'])
except FileNotFoundError:
    pass