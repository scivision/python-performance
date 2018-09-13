
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

%%
function x = simple_iter(A) %must return at least one argument or timeit breaks
  x=0;
  for i = A
    x = 0.5*x + mod(i, 10);
    if x>1e100; break; end
  end
end
