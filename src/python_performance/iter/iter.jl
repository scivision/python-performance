function f(N)
x = 0.
    for ii = 0:N-1
        x = 0.5*x + mod(ii,10)
    end
return x
end

println("simple_iter:   N: $N")
o=@benchmark f(N)
println(o)
