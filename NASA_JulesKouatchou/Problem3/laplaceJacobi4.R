#!/usr/bin/env Rscript

args = commandArgs(TRUE)

#####################################################
# Get the number of grid points from the command line
#####################################################

if (length(args)==0) {
  cat("Usage: Rscript jacobiSolver_order4.R numPoints \n")
  stop("       --->      Please specify the number of grid points.", call.=FALSE)
}
numPoints <- as.integer(args[1])

pi_c <- 4.0*atan(1.0)

cat("--------------------------------------------------\n")
cat("Regular Solver (loop) for Fourth-Order Scheme: ", numPoints, "\n")
cat("--------------------------------------------------\n")
cat(" \n")

regularTimeStep <- function(u){
    n <- dim(u)[1] - 1
    m <- dim(u)[2] - 1

    err <- 0.0
    for (j in 2:m){
        for (i in 2:n){
            tmp <- u[i,j]
            u[i,j] <- ( ((u[i-1,j] + u[i+1,j] + u[i,j-1] + u[i,j+1])*4.0 +
                       u[i-1,j-1] + u[i-1,j+1] + u[i+1,j-1] + u[i+1,j+1])/20.0 )

            diff <- u[i,j] - tmp
            err <- err + diff*diff
        }
    }
    output <- list("u"=u, "err"=sqrt(err))

    return(output)
}


u <- array(0.0, dim=c(numPoints,numPoints))

i <- 1:numPoints
x <- (i-1)*pi_c/(numPoints-1)

u[1, ] <- sin(x)
u[numPoints, ] <- sin(x)*exp(-pi_c)

regularSolver <- function(u) {
   iter <- 0
   err  <- 2
   while(iter < 100000 && err > 1e-6) {
      A <- regularTimeStep(u)
      u <- A$u
      err <- A$err
      iter <- iter + 1
   }
   output = list("u"=u, "err"=err, "iter"=iter)
   return (output)
}

btm <- proc.time()
A <- regularSolver(u)
etm <- proc.time()

etm - btm

cat(" \n")
cat("   ji  Number of iterations: ", A$iter, "\n")
cat("       Error:", A$err, "\n")
cat(" \n")

cat("-----------------------------------------\n")
cat("Vectorized Solver for Fourth-Order Scheme: ", numPoints, "\n")
cat("-----------------------------------------\n")
cat(" ")

vectorizedTimeStep <- function(u) {
    n <- dim(u)[1]
    m <- dim(u)[2]

    u_old <- u

    n1 <- n-1
    n3 <- n-2

    m1 <- m-1
    m3 <- m-2

    u[2:n1, 2:m1] <- ( ((u[1:n3, 2:m1] + u[3:n,  2:m1] +
                       u[2:n1, 1:m3] + u[2:n1, 3:m])*4.0 +
                       u[1:n3, 1:m3] + u[1:n3, 3:m] +
                       u[3:n,  1:m3] + u[3:n,  3:m])/20.0 )

    v <- as.vector(u - u_old)
    err = v%*%v
    output <- list("u"=u, "err"=sqrt(err[1]))

    return(output)
}

v <- array(0.0, dim=c(numPoints,numPoints))

i <- 1:numPoints
x <- (i-1)*pi_c/(numPoints-1)

v[1,] <- sin(x)
v[numPoints, ] <- sin(x)*exp(-pi_c)

vectorizedSolver <- function(v){
   iter <- 0
   err  <- 2.0
   while(iter <100000 && err>1e-6) {
      A <- vectorizedTimeStep(v)
      v <- A$u
      err <- A$err
      iter <- iter + 1
   }
   output = list("u"=v, "err"=err, "iter"=iter)
   return (output)
}

btm <- proc.time()
A <- vectorizedSolver(v)
etm <- proc.time()

etm - btm

cat(" \n")
cat("       Number of iterations: ", A$iter, "\n")
cat("       Error:", A$err, "\n")
