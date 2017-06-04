#!/usr/bin/env python


import sys
if len(sys.argv) < 1:
	print 'Usage:'
	print '     ./copyMatrix.py dim'
	print 'Please specify matrix dimensions'
	sys.exit()

from numpy import *
from time import *

dim = int(sys.argv[1])


# Copy with loop
#----------------
A = random.rand(dim,dim,3)

start = clock()
for i in range(dim):
    for j in range(dim):
        A[i,j,0] = A[i,j,1]
        A[i,j,2] = A[i,j,0]
        A[i,j,1] = A[i,j,2]

finish = clock()
print 'Time for copy with loops: ', finish - start,'s'
print

# Vectorized Copy
#----------------
A = random.rand(dim,dim,3)

start = clock()
A[:,:,0] = A[:,:,1]
A[:,:,2] = A[:,:,0]
A[:,:,1] = A[:,:,2]

finish = clock()
print 'Time for vectorized copy: ', finish - start,'s'
print
