% **********************************************************
% Given two nxn matrices A and B, we perform:
%       C = A x B
% ********************************************************** 
 
%matlab -nodesktop -nojvm -nosplash -r "matMult(1500)"

function matMult(nx)
A = rand (nx);
B = rand (nx);

disp(nx);

tic

AB = A * B;

toc

exit;

