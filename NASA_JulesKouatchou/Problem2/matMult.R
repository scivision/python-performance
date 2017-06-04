#!/usr/bin/env Rscript

args = commandArgs(TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (dimension).n", call.=FALSE)
} else if (length(args)==1) {
  n <- as.integer(args[1])
}

cat('---------------------------------------\n')
cat('     Multiplication of matrices: ', n, '\n')
cat('---------------------------------------\n')

A <- matrix(rnorm(n*n), n)
B <- matrix(rnorm(n*n), n)

dim(A)[1]

# Start the clock!
btm <- proc.time()

C <- A %*% B

# Stop the clock
etm <- proc.time()

etm - btm
cat('---------------------------------------\n')
cat(' \n')
