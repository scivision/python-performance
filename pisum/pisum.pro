pro pisum
N=1000000
s=0.


tic
for k=1,N+1 do begin
    s = s+(-1.)^(k+1) / (2*k-1)
    if (s gt 1e100) then break
endfor
s=4*s
toc

if (abs(s-!const.pi) gt 1e-4) then begin
    print,'|error| = ',abs(s-!const.pi)
    printf,-2,k,' ',s,' ERROR GDL: failed to converge'
endif


end

