#!/usr/bin/env julia
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
  N = 1000000
else
  N = parse(Int, ARGS[1]);
end

println("--> Julia $VERSION    N: $N")

function g(N::Int)
  s = 0.
  for k = 1:N+1
    s = s + (-1.)^(k+1) / (2*k-1)
  end

  x::Real=4.0*s
return x
end

@test isapprox(g(N), pi, atol=1e-4)
o = @benchmark g(N)
println(minimum(o).time/1e9, " seconds")
