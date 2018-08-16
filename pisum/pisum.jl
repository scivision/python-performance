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
  N = 100
else
  N = parse(Int,ARGS[1]);
end

function f(N)
x = 0.
    for ii = 0:N-1
        x = 0.5*x + mod(ii,10)
        if x>1e100; break; end  # to break JIT
    end
return x
end

println("simple_iter:   N: $N")
o=@benchmark f(N)
println(o)

function g(N)
  s = 0.
  for k = 1:N+1
    s = s + (-1)^(k+1) / (2*k-1)
  end

  x=4*s


return x
end

@assert abs(g(N)-pi) < 0.01
println("pisum:   N: $N")
o=@benchmark g(N)
println(o)
