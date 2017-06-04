# **********************************************************
# Given a nxnx3 matrix A, we want to perform the operations:
#
#       A[i][j][0] = A[i][j][1]
#       A[i][j][2] = A[i][j][0]
#       A[i][j][1] = A[i][j][2]
# **********************************************************

#########################################
# Get the dimension from the command line
#########################################
n, = size(ARGS)
if (n < 1)
   println("Usage: copyMatrix.jl dim")
   println("       --->      Please specify the dimension.")
   exit()
end


dim = parse(Int, ARGS[1])

# Loop
#-----
function foo1(A)
   N = size(A, 1)
   for j = 1:N, i = 1:N
       A[i,j,1] = A[i,j,2]
       A[i,j,3] = A[i,j,1]
       A[i,j,2] = A[i,j,3]
   end
end

println("-------------------------------")
println(@sprintf "Copy of matrix (loop) %d" dim)
println("-------------------------------")

A = randn(dim,dim,3)

tic()
foo1(A)
toc()

println(" ")

println("--------------------------")
println(@sprintf "Vectorized Copy of matrix %d" dim)
println("--------------------------")

A = randn(dim,dim,3)

tic()

A[:,:,1] = A[:,:,2]
A[:,:,3] = A[:,:,1]
A[:,:,2] = A[:,:,3]

toc()
println(" ")
