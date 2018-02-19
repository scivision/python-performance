pro matmul

argv = command_line_args()
N=uint(argv)

A=randomu(seed,N,N)
B=randomu(seed,N,N)
print,'N=',N

tic
c=matrix_multiply(A,B)
toc


end
