N=1000;
 A = randn(N,N);
 B = randn(N,N);
 f = @() A*B;

v=ver(:);
for i = 1:length(v)
    fprintf([v(i).Name,' ',v(i).Version,': '])
end

if ~isoctave
 timeit(f)
else
 tcum = inf;
 for i=1:10
    tic
    f();
    t=toc;
    tcum=min(tcum,t);
 end
    fprintf(['N=',int2str(N),' ',num2str(tcum*1e3),' ms.\n'])
end
