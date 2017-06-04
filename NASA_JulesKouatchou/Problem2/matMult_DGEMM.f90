! **********************************************************
! Given two nxn matrices A and B, we perform:
!       C = A x B
! **********************************************************

      program matMult_DGEMM
      
      IMPLICIT NONE

      integer iseed /3/
      real start, finish
 
      real :: r
      integer :: n, i, j
      double precision, allocatable :: A(:,:), B(:, :), C(:, :)
      DOUBLE PRECISION ALPHA,BETA
      INTEGER LDA,LDB,LDC

      CHARACTER(len=30) :: arg(1)

      ! Get the dimension from the command line
      !----------------------------------------
      call getarg(1,arg(1))
      read(arg(1), * ) n

      ALPHA = 1.0d0
      BETA  = 0.0d0
      LDA = n
      LDB = n
      LDC = n

      !-------------------------------------
      ! Allocate and initialize the matrices
      !-------------------------------------

      allocate(A(n,n))
      allocate(B(n,n))
      allocate(C(n,n))

      call srand(86456)
      do i = 1, n
         do j = 1, n
            call random_number(r)
            A(i, j) = r
            call random_number(r)
            B(i, j) = r
         enddo
      enddo

      !----------------------------------
      ! Perform the matrix multiplication
      !----------------------------------
      C = 0.0d0
      call cpu_time(start)

      call dgemm("N","N",n,n,n,alpha,A,lda,B,ldb,beta,C,ldc)

      call cpu_time(finish)
      print *,'Matrix multiplication with DGEMM: time for C(',n,',',n,') = A(',n,',',n,') B(', &
     &  n,',',n,') is',finish - start,' s'

      end program matMult_DGEMM

