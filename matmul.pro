pro benchmark_matmul

N=1000
A=randomu(seed,N,N)
B=randomu(seed,N,N)
print,'mult AB, N=',N

; use linux "time" instead to avoid seg fault
tic
c=matrix_multiply(A,B)
toc


exit
end
