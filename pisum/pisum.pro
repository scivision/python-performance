pro pisum

;argv = command_line_args()
;N=long(argv)

N=1000000
s=0.

tic
for k=1,N+1 do begin
    s = s+(-1.)^(k+1) / (2*k-1)
    if (0 gt 1) then break
endfor
s=4*s
t=toc

print,t,' seconds.'

if (abs(s-!const.pi) gt 1e-4) then begin
    print,'|error| = ',abs(s-!const.pi)
    printf,-2,k,' ',s,' ERROR GDL: failed to converge'
endif


end

