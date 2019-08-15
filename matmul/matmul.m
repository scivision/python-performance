function matmul(N, Nrun)

addpath('..')

if nargin < 2, Nrun=10; end
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
tcum = timeit(f);
catch % octave
tcum = inf;
for i=1:Nrun
  tic
  f();
  tcum=min(tcum,toc);
end
end % try
disp([num2str(tcum),' seconds for N=',int2str(N)])

end % function
