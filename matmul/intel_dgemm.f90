use,intrinsic :: iso_fortran_env, only: dp=>real64

IMPLICIT NONE

external :: dgemm
real(dp) ALPHA, BETA
INTEGER          M, K, N, I, J
PARAMETER        (M=2000, K=200, N=1000)
real(dp) A(M,K), B(K,N), C(M,N)

PRINT *, "Initializing data for matrix multiplication C=A*B for "
PRINT '(a,I5,a,I5,a,I5,a,I5,a,/)', " matrix A(",M," x",K, ") and matrix B(", K," x", N, ")"

ALPHA = 1
BETA = 0

PRINT *, "Intializing matrix data"
PRINT *, ""
forall (I = 1:M, J = 1:K)  A(I,J) = (I-1) * K + J

forall (I = 1:K, J = 1:N)  B(I,J) = -((I-1) * N + J)

C(:,:) = 0

PRINT *, "Computing matrix product using DGEMM subroutine"
CALL DGEMM('N','N',M,N,K,ALPHA,A,M,B,K,BETA,C,M)


PRINT *, "Top left corner of matrix A:"
PRINT '(6(F12.0,1x),/)', ((A(I,J), J = 1,MIN(K,6)), I = 1,MIN(M,6))

PRINT *, "Top left corner of matrix B:"
PRINT '(6(F12.0,1x),/)', ((B(I,J),J = 1,MIN(N,6)), I = 1,MIN(K,6))

PRINT *, "Top left corner of matrix C:"
PRINT '(6(ES12.4,1x),/)', ((C(I,J), J = 1,MIN(N,6)), I = 1,MIN(M,6))

end program
