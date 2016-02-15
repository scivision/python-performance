#!/bin/sh
##################
mfn="/tmp/mat.m"
echo " A = randn(5000,5000);
 B = randn(5000,5000);
 f = @() A*B;
 timeit(f)" >> $mfn

#matlab -nodesktop -nojvm -nosplash -r "run('$mfn')"

######################
pfn=$(mktemp)
echo 'import timeit

t = timeit.Timer("A*B","import numpy as np; A = np.array(np.random.randn(5000,5000)); B = np.array(np.random.randn(5000,5000))")
print(t.timeit(50)/50.)
' >> $pfn

python $pfn
