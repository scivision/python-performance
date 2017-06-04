%###############################################
% Numerical solution of the Laplace's equation.
%
%  u   + u   = 0
%   xx    yy
%
% Fourth-order compact Scheme
% Jacobi's iteration
%###############################################

%matlab -nodesktop -nojvm -nosplash -r "laplaceJacobi4_vect(50)"

function laplaceJacobi4_vect(nx)
xmin = 0;
xmax = 1;
ymin = 0;
ymax = 1;
 
%nx = 100;
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
    u(2:end-1, 2:end-1) = ((u(1:end-2, 2:end-1) + u(3:end, 2:end-1) + u(2:end-1,1:end-2) + u(2:end-1, 3:end))*4.0 + u(1:end-2, 1:end-2) + u(1:end-2, 3:end) + u(3:end,1:end-2) + u(3:end, 3:end))/20.0;
    v = (u - u_old);
    err = sqrt(v(:).'*v(:));
end

fprintf('Jacobi with Matlab - Vectorization \n');
fprintf('     Number of iterations: %5g \n', count);
fprintf('     Error: %12.10f \n', err);

toc

exit;
