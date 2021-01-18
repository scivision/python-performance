pro pisum

argv = command_line_args()
N=long(argv[0])

printf,-1,!VERSION.release, N

s=0.

tic
for k=1, N+1 do begin
    s = s + (-1.)^(k+1) / (2*k-1)
endfor

s = 4.*s
t=toc()

err = abs(s-!const.pi)
if (err gt 1e-4) then begin
    printf,-2,'Pisum: failed to converge, error magnitude',err
    exit,STATUS=2,/NO_CONFIRM
endif

print,t,' seconds.'

end

