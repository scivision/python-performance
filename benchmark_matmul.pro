pro matmul

N=5000
A=randomu(seed,N,N)
B=randomu(seed,N,N)
print,'mult AB, N=',N
tic
c=matrix_multiply(A,B)
toc

end
