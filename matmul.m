N=5000;
 A = randn(N,N);
 B = randn(N,N);
 f = @() A*B;

v=ver;
fprintf([v.Name,' ',v.Version,': '])

if ~isoctave
 timeit(f)
else
 tcum = inf;
 for i=1:1
    tic
    f();
    t=toc;
    tcum=min(tcum,t);
 end
    fprintf([num2str(tcum),' seconds.\n'])
end
