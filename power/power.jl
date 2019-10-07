#!/usr/bin/env julia

using BenchmarkTools

function caret(x, y)
  z = x ^ y

  return z
end

o = @benchmark caret(10, -3.)
println(minimum(o).time, " nanoseconds")