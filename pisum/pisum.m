function pisum(N)

  addpath('..')
  Nrun=3;

  if isoctave
      v = ver('octave'); % else matlab syntax checker errors
      disp(['--> Octave ', v.Version])
  else
      v = ver('matlab');
      disp(['--> Matlab ',v.Version])
  end

  %% simple_iter
  fprintf('simple_iter ')
    A = rand(N,1);
    try
      f = @() simple_iter(A); % this anon function required by timeit
      t=timeit(f);
    catch
      t = inf;
      tic
      simple_iter(A);
      t = min(toc,t);
    end
  disp([num2str(t),' sec.'])

%% mandelbrot
  %mandel(complex(-.53,.68));
  %assert(sum(sum(mandelperf(true))) == 14791)

  fprintf('mandelbrot ')
  try
    f = @() mandelperf(false);
    t=timeit(f);
  catch
    t = inf;
    tic
    mandelperf();
    t = min(toc,t);
  end
  disp([num2str(t),' sec.'])
%% pisum
  fprintf('pisum ')
    try
      f = @() calcpisum(N);
      t = timeit(f);
    catch
      t = inf;
      for i = 1:Nrun
          tic
          calcpisum(N);
          t = min(toc,t);
      end
    end % try
  disp([num2str(t),' sec.'])

end % function iter
%%
function x = calcpisum(N)
  s = 0.;
  for k = 1:N
    s = s + (-1)^(k+1) / (2*k-1);
  end

  x=4*s;
end
%%
function x = simple_iter(A) %must return at least one argument or timeit breaks
  x=0;
  for i = A
    x = 0.5*x + mod(i, 10);
    if x>1e100; break; end
  end
end
%%
function n = mandel(z)
  c = z;
  for n=0:79
    if abs(z)>2
      return
    end
    z = z^2+c;
  end
  n = 80;
end
%%
function M = mandelperf(~)
  x=-2.0:.1:0.5;
  y=-1:.1:1;
  M=zeros(length(y),length(x));
  for r=1:size(M,1)
    for c=1:size(M,2)
     M(r,c) = mandel(x(c)+y(r)*1j);
    end
  end
end

