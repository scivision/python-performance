#!/usr/bin/env julia

A = randn(5000,5000); 
B = randn(5000,5000);
@time A*B;
