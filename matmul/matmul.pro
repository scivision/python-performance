pro matmul

argv = command_line_args()
N=long(argv[0])

A=randomu(seed,N,N)
B=randomu(seed,N,N)


tic
c=matrix_multiply(A,B)
t=toc()

print,'matmul: ',t,' seconds.'


end
