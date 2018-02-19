#!/usr/bin/env julia
println("--> Julia $VERSION")

#Pkg.add("BenchmarkTools")
#Pkg.update("BenchmarkTools")
using BenchmarkTools

N = parse(Int,ARGS[1]);

A = randn(N,N);
B = randn(N,N);

o=@benchmark A*B;
println(o)