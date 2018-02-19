function matmul(N)

  addpath('..')

  Nrun=10;
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
    for i=1:Nrun
      tic
      f();
      t=toc;
      tcum=min(tcum,t);
    end

    disp([num2str(tcum),' seconds for N=',int2str(N)])
  end % try

end % function
