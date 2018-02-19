#!/usr/bin/env julia
N = 1000;

A = randn(N,N); 
B = randn(N,N);

@time A*B;
