#!/usr/bin/env julia
println("--> Julia")

Pkg.add("BenchmarkTools")
using BenchmarkTools

function f(N) 
x = 0.
    for ii = 0:N-1
        x = 0.5*x + mod(ii,10)
        if x>1e100; break; end
    end
return x
end

println("simple_iter")
o=@benchmark f(10^6)
println(o)

function g(N)
  s = 0.
  for k = 1:N+1
    s = s + (-1)^(k+1)/(2*k-1)
  end

  x=4*s

return x
end

println("pisum")
o=@benchmark g(10^6)
println(o)
