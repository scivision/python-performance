function matmul(~)

addpath('..')

N=1000;
%%
if isoctave
    v = ver('octave'); % else matlab syntax checker errors
    disp(['--> Octave ', v.Version])
else
    v = ver('matlab');
    disp(['--> Matlab ',v.Version])
end
%%

 A = randn(N,N);
 B = randn(N,N);
 f = @() A*B;

try % matlab
  timeit(f)
catch % octave
  tcum = inf;
  for i=1:10
    tic
    f();
    t=toc;
    tcum=min(tcum,t);
  end
  
  fprintf(['N=',int2str(N),' ',num2str(tcum*1e3),' ms.\n'])
end % try

end % function
