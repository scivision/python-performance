
################################################
# Numerical solution of the Laplace's equation.
#
#  u   + u   = 0
#   xx    yy
#
# Fourth-order compact Scheme
# Jacobi's iteration
################################################

#-------------------------------------
# Function for Jacobi sweep with loops
#-------------------------------------
function regularTimeStep(u::Matrix)
    (n, m) = size(u)

    err = 0.0
    for i in 2:n-1
        for j in 2:m-1
            tmp = u[i,j]
            u[i,j] = ((u[i-1, j] + u[i+1, j] +
                       u[i, j-1] + u[i, j+1])*4.0 +
                       u[i-1,j-1] + u[i-1,j+1] +
                       u[i+1,j-1] + u[i+1,j+1])/20.0

            diff = u[i,j] - tmp
            err = err + diff*diff
        end
    end

    return u, sqrt(err)
end

#-------------------------------------
# Function for vectorized Jacobi sweep
#-------------------------------------
function vectorizedTimeStep(u::Matrix)
    (n, m) = size(u)
    u_old = copy(u)

    u[2:n-1, 2:m-1] = ((u[1:n-2, 2:m-1] + u[3:n,   2:m-1] +
                        u[2:n-1, 1:m-2] + u[2:n-1, 3:m])*4.0 +
                        u[1:n-2, 1:m-2] + u[1:n-2, 3:m] +
                        u[3:n,   1:m-2] + u[3:n,   3:m])/20.0

    v = vec(u - u_old)
    return u, sqrt(dot(v,v))
end


#####################################################
# Get the number of grid points from the command line
#####################################################
n, = size(ARGS)
if (n < 1)
   println("Usage: jacobiDriver4.jl numPoints")
   println("       --->      Please specify the number of grid points.")
   exit()
end

numPoints = parse(Int, ARGS[1])

pi_c = 4.0*atan(1.0)

println("------------------------------------------------")
println("Regular Solver (ij loop) for Fourth-Order Scheme: ", numPoints)
println("------------------------------------------------")
println(" ")

u = zeros(Float32, numPoints,numPoints)

x=[(i-1)*pi_c/(numPoints-1) for i in 1:numPoints]

u[1,:] = [sin(a) for a in x]
u[numPoints,:] = [sin(a)*exp(-pi_c) for a in x]

function regularSolver(u)
   iter =0
   err = 2
   while(iter <100000 && err>1e-6)
      (u,err)=regularTimeStep(u)
      iter+=1
   end
   return (u,err,iter)
end


@time (u,err,iter) = regularSolver(u)

println(" ")
println("   ij  Number of iterations: ", iter)
println("       Error:", err)
println(" ")

println("-----------------------------------------")
println("Vectorized Solver for Fourth-Order Scheme: ", numPoints)
println("-----------------------------------------")
println(" ")

v = zeros(Float32, numPoints,numPoints)

x=[(i-1)*pi_c/(numPoints-1) for i in 1:numPoints]

v[1,:] = [sin(a) for a in x]
v[numPoints,:] = [sin(a)*exp(-pi_c) for a in x]

function vectorizedSolver(v)
   iter =0
   err = 2
   while(iter <100000 && err>1e-6)
      (v,err)=vectorizedTimeStep(v)
      iter+=1
   end
   return (v,err,iter)
end

@time (v,err,iter) = vectorizedSolver(v)

println(" ")
println("       Number of iterations: ", iter)
println("       Error:", err)
