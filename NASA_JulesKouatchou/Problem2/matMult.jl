# **********************************************************
# Given two nxn matrices A and B, we perform:
#       C = A x B
# **********************************************************

n, = size(ARGS)
if (n < 3)
   println("Usage: matrixMult.jl dim1 dim2 dim3")
   println("       ---> Please specify the dimensions.")
   exit()
end

dim1 = parse(Int, ARGS[1])
dim2 = parse(Int, ARGS[2])
dim3 = parse(Int, ARGS[3])


println("----------------------------")
println(@sprintf "Matrix dimensions: %d, %d, %d" dim1 dim2 dim3)
println("----------------------------")
println(" ")

A = randn(dim1,dim2)
B = randn(dim2,dim3)
C = zeros(dim1,dim3)

# Long way: multiply two matrices
#-------------------------------
#println("Long way: multiply two matrices")
#
#tic()
#for i in 1:dim1
#    for j in 1:dim3
#        for k in 1:dim2
#            C[i, j] += A[i, k]*B[k, j]
#        end
#    end
#end
#
#toc()

println(" ")

# Quick way: multiply two matrices
#---------------------------------
println("Quick way: multiply two matrices")
tic()

C = A*B

toc()
