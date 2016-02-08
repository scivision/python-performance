function bench_iter()
A=rand(1000000,1);
% if statement just to break loop unrolling
f = @() fun(A); % this anon function required by timeit
timeit(f)

end

function x= fun(A) %must return at least one argument or timeit breaks
 x=0;
    for i = A
        x = 0.5*x + mod(i, 10);
        if x>1e100
            break
        end
    end 
end

