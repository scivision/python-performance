#!/usr/bin/env julia
println("--> Julia $VERSION")
using Test

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



function g(N::Int)
  s = 0.
  for k = 1:N+1
    s = s + (-1)^(k+1) / (2*k-1)
  end

  x=4*s
return x
end

@test isapprox(g(100), pi, atol=0.01)
println("pisum:   N: $N")
o = @benchmark g(N)
println(o)
