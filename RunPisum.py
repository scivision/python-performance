#!/usr/bin/env python
from __future__ import print_function
from pythonperformance import Path
from time import time
import subprocess as S
from six import PY2
if PY2:
    FileNotFoundError=OSError

bdir = Path('pisum')
#%% Fortran
try:
    S.check_call(['./bin/iter'])
except FileNotFoundError:
    pass
#%% Julia
try:
    S.check_call(['julia',str(bdir/'iter.jl')])
except FileNotFoundError:
    pass
#%% GDL
try:
    tic = time()
    S.check_call(['gdl','-q','-e','.run '+str(bdir/'pisum.pro')])
    print('--> GDL',end=' ')
    print('{:.2f} seconds'.format(time()-tic))
except FileNotFoundError:
    pass

#%% Octave
try:
    S.check_call(['octave','-q','--eval','run '+ str(bdir/'iter.m')])
    print('TODO: Octave does not stdout for eval')
except FileNotFoundError:
    pass
#%% Matlab
try:
    S.check_call(['matlab','-nodesktop','-nojvm','-nosplash','-r',
           'run ' + str(bdir/'iter.m') + '; exit'])
except FileNotFoundError:
    pass

#%% Python
try:
    S.run(['ipython',str(bdir/'pisum.ipy')])
except FileNotFoundError:
    print('skip Python')
    pass
