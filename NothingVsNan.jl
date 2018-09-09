#!/usr/bin/env julia
#=
performance is the same for isnan() and == nothing in Julia
=#
println("--> Julia $VERSION")

try
  using BenchmarkTools
catch
  import Pkg
  Pkg.add("BenchmarkTools")
  Pkg.update("BenchmarkTools")
  using BenchmarkTools
end

function fnan()
for i = 0:100
   x = isnan(i)
   if i > 1e100; break; end  # to break JIT
end
end


function fnothing()
for i = 0:100
   x = nothing == 0.
   if i > 1e100; break; end  # to break JIT
end
end


o=@benchmark fnan()
println("isnan", o)

println("is nothing")
o=@benchmark fnothing()
println(o)

