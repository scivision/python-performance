#!/usr/bin/env python

################################################
# Numerical solution of the Laplace's equation.
#
#  u   + u   = 0
#   xx    yy
#
# Fourth-order compact Scheme
# Jacobi's iteration
################################################

import numpy
import sys
import time
import math


def slowTimeStep(u):
    """Takes a time step using straight forward Python loops."""
    n, m = u.shape

    err = 0.0
    for i in range(1, n-1):
        for j in range(1, m-1):
            tmp = u[i,j]
            u[i,j] = ((u[i-1, j] + u[i+1, j] +
                       u[i, j-1] + u[i, j+1])*4.0 +
                       u[i-1,j-1] + u[i-1,j+1] +
                       u[i+1,j-1] + u[i+1,j+1])/20.0

            diff = u[i,j] - tmp
            err += diff*diff

    return u,numpy.sqrt(err)

def numpyTimeStep(u):
    u_old=u.copy()
    u[1:-1, 1:-1] = ((u[0:-2, 1:-1] + u[2:, 1:-1] +
                      u[1:-1,0:-2] + u[1:-1, 2:])*4.0 +
                      u[0:-2, 0:-2] + u[0:-2, 2:] +
                      u[2:,0:-2] + u[2:, 2:])/20.0
    v = (u - u_old).flat
    return u,numpy.sqrt(numpy.dot(v,v))

# number of grid points
numPoints = int(sys.argv[1])

j=numpy.complex(0,1)
pi_c = 4.0*math.atan(1.0)

##################################
# Setting of the initial condition
##################################

u=numpy.zeros((numPoints,numPoints),dtype=float)

################################
# Setting the boundary condition
################################

x=numpy.r_[0.0:pi_c:numPoints*j]
u[0,:]=numpy.sin(x)
u[numPoints-1,:]=numpy.sin(x)*numpy.exp(-pi_c)

def regularSolver(u):
   iter =0
   err = 2
   while(iter <100000 and err>1e-6):
      (u,err)=slowTimeStep(u)
      iter+=1
   return (u,err,iter)

begTime1 = time.time()

(u,err,iter) = regularSolver(u)

endTime1 = time.time()
print " "
print "Regular Solver for Fourth-Order Scheme: ", numPoints
print "       Elapsed time: ", endTime1 - begTime1,"(s)"
print "       Number of iterations: ", iter
print "       Error:", err
#
# Vectorized Solver

v=numpy.zeros((numPoints,numPoints),dtype=float)

x=numpy.r_[0.0:pi_c:numPoints*j]
v[0,:]=numpy.sin(x)
v[numPoints-1,:]=numpy.sin(x)*numpy.exp(-pi_c)


def fastSolver(v):
   iter =0
   err = 2
   while(iter <100000 and err>1e-6):
      (v,err)=numpyTimeStep(v)
      iter+=1
   return (v,err,iter)

begTime2 = time.time()

(v,err,iter) = fastSolver(v)

endTime2 = time.time()
print " "
print "Vectorized Solver for Fourth-Order Scheme: ", numPoints
print "       Elapsed time: ", endTime2 - begTime2,"(s)"
print "       Number of iterations: ", iter
print "       Error:", err

