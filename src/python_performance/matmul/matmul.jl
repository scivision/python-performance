#!/usr/bin/env julia
println("--> Julia $VERSION")

try
  using BenchmarkTools
catch
  import Pkg
  Pkg.add("BenchmarkTools")
  Pkg.update("BenchmarkTools")
  using BenchmarkTools
end

if length(ARGS) < 1
  N = 1000
else
  N = parse(Int, ARGS[1]);
end

A = randn(N,N);
B = randn(N,N);

o=@benchmark A*B;
println("N: $N")
println(minimum(o).time/1e9, " seconds")
