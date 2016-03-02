 A = randn(5000,5000);
 B = randn(5000,5000);
 f = @() A*B;
 timeit(f)
