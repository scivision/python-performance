#!/usr/bin/env python

import sys
if len(sys.argv) < 2:
	print 'Usage:'
	print '     ./matMult.py dim1 dim2 dim3'
	print 'Please specify matrix dimensions'
	sys.exit()

from numpy import *
from time import *

dim1 = int(sys.argv[1])
if len(sys.argv) < 3:
	dim2 = dim1
else:
	dim2 = int(sys.argv[2])
if len(sys.argv) < 4:
	dim3 = dim1
else:
	dim3 = int(sys.argv[3])

A = random.rand(dim1,dim2)
B = random.rand(dim2,dim3)

start = clock()

C = dot(A,B)

finish = clock()
print 'time for','C'+str(shape(C)),'=','A'+str(shape(A)),'B'+str(shape(B)),'is', finish - start,'s'
