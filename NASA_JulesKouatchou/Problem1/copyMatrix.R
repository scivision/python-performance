#!/usr/bin/env Rscript

args = commandArgs(TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (dimension).n", call.=FALSE)
} else if (length(args)==1) {
  n <- as.integer(args[1])
}

cat('-----------------------------------------\n')
cat('           Copy Matrix - loop: ', n,         '\n')
cat('-----------------------------------------\n')

A <- array(rnorm(n*n*3), dim=c(n,n,3))

# Start the clock!
btm <- proc.time()

for (j in 1:n){
    for (i in 1:n){
        A[i,j,1] <- A[i,j,2]
        A[i,j,3] <- A[i,j,1]
        A[i,j,2] <- A[i,j,3]
    }
}

# Stop the clock
etm <- proc.time()

etm - btm
cat('---------------------------------------\n')
cat(' \n')


cat('-----------------------------------------\n')
cat('           Copy Matrix - vectorized: ', n,         '\n')
cat('-----------------------------------------\n')

A <- array(rnorm(n*n*3), dim=c(n,n,3))

# Start the clock!
btm <- proc.time()

A[,,1] <- A[,,2]
A[,,3] <- A[,,1]
A[,,2] <- A[,,3]

# Stop the clock
etm <- proc.time()

etm - btm
cat('---------------------------------------\n')
cat(' \n')
