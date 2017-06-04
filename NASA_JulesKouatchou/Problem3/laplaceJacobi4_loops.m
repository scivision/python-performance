%###############################################
% Numerical solution of the Laplace's equation.
%
%  u   + u   = 0
%   xx    yy
%
% Fourth-order compact Scheme
% Jacobi's iteration
%###############################################
 
%matlab -nodesktop -nojvm -nosplash -r "laplaceJacobi4_loops(50)"
function laplaceJacobi4_loops(nx)
xmin = 0;
xmax = 1;
ymin = 0;
ymax = 1;
 
ny = nx;
 
dx = (xmax - xmin) / (nx - 1);
dy = (ymax - ymin) / (ny - 1);
 
x = xmin:dx:xmax;
y = ymin:dy:ymax;
 
n_iter = 10000;
eps = 1e-6;
 
u = zeros(nx,ny);
u(:,1)   = sin(x.*pi);
u(:,end) = sin(x.*pi)*exp(-pi);
err = Inf;
count = 0;

tic

while err > eps && count < n_iter
    count = count + 1;
    u_old = u;
    for j = 2:ny-1
        for i=2:nx-1
            u(i,j) = ((u(i-1, j) + u(i+1,j) + u(i,j-1) + u(i,j+1))*4.0 + u(i-1,j-1) + u(i-1,j+1) + u(i+1,j-1) + u(i+1,j+1))/20.0;
        end
    end 
    v = (u - u_old);
    err = sqrt(v(:).'*v(:));
end

fprintf('Jacobi with Matlab - for loops \n');
fprintf('     Number of iterations: %5g \n', count);
fprintf('     Error: %12.10f \n', err);

toc

exit;
