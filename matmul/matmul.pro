pro matmul

argv = command_line_args()
N=long(argv)

A=randomu(seed,N,N)
B=randomu(seed,N,N)


tic
c=matrix_multiply(A,B)
toc


end
