pro bench_iter

N=1000000
A=randomu(seed,N)
x=0

; use linux "time" instead to avoid seg fault
;tic
for i=1,N do x = 0.5*x + i MOD 10
;toc
;print,x

exit
end
