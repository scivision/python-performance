! **********************************************************
! Given two nxn matrices A and B, we perform:
!       C = A x B
! **********************************************************

      program matMult_loops

      IMPLICIT NONE

      real :: r

      real start, finish

      integer dim
      double precision, allocatable :: A(:,:), B(:, :), C(:, :)

      integer :: i, j, k
      integer, parameter :: n = 1
      CHARACTER(len=50) :: arg(n)

      ! Get the dimension from the command line
      !----------------------------------------
      do i =1, n
         call getarg(i,arg(i))
      end do
      read(arg(1), * ) dim

      !-------------------------------------
      ! Allocate and initialize the matrices
      !-------------------------------------
      allocate(A(dim,dim))
      allocate(B(dim,dim))
      allocate(C(dim,dim))

      call srand(86456)
      do i = 1, dim
         do j = 1, dim
            call random_number(r)
            A(i, j) = r
            call random_number(r)
            B(i, j) = r
         enddo
      enddo

      !----------------------------------
      ! Perform the matrix multiplication
      !----------------------------------
      call cpu_time(start)
      do j = 1, dim
         do i = 1, dim
            C(i, j) = 0.
            do k = 1, dim
               C(i, j) = C(i, j) + A(i, k)*B(k, j)
            enddo
         enddo
      enddo
      call cpu_time(finish)

      print *,'Matrix multiplication with loops: time for C(',dim,',',dim,') = A(',dim,',',dim,') B(', &
     &   dim,',',dim,') is',finish - start,' s'

      end program matMult_loops
