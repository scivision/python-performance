pro pisum

N=100000
s=0.

; use linux "time" instead to avoid seg fault
;tic
for k=1,N+1 do s = s+(-1)^(k+1)/(2*k-1)
s=4*s
;toc
assert,abs(s-!const.pi)<1e-4,'failed to converge GDL'
end
