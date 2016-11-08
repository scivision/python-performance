#!/usr/bin/env julia

function f(n) x = 0.; for ii = 0:n-1; x = 0.5*x + mod(ii,10); if x>1e100; break; end; end; return x; end
@time f(10^6)
