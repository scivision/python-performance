!----------------------------------------------------------------------
! Numerical solution of the 2D Laplce equation:
!
!    u   + u   = 0
!     xx    yy
!----------------------------------------------------------------------
      program laplaceJacobi4_vect

      implicit none

      double precision, parameter :: eps = 1.0d-6
      integer,          parameter :: max_sweep = 1000000
      INTEGER :: n
      DOUBLE PRECISION, allocatable :: u(:,:)
      DOUBLE PRECISION, allocatable :: v(:,:)
      DOUBLE PRECISION, allocatable :: x(:)

      double precision :: error
      double precision :: pi
      integer :: count, i
      real :: start, finish

      CHARACTER(len=30) :: arg(1)

      call cpu_time(start)
      ! Get the dimension from the command line
      !----------------------------------------
      call getarg(1,arg(1))
      read(arg(1), * ) n

      !-------------------------------------------
      ! Variable allocation and initial conditions
      !-------------------------------------------
      allocate(u(n,n))
      allocate(v(n,n))
      allocate(x(n))

      pi = 3.141592653589793d0

      do i = 1, n
         x(:) = 1.0d0*(i-1)/n
      end do

      u(:,:) = 0.0d0
      u(:,1) = sin(pi*x(:))
      u(:,n) = sin(pi*x(:))*exp(-pi)

      error = 2d0
      count = 0

      !------------------
      ! Jacobi iterations
      !------------------

      do while ( (count < max_sweep) .and. (error > eps))
         count = count + 1
         v(:,:) = u(:,:)
         u(2:n-1,2:n-1) = ((v(1:n-2,2:n-1) + v(3:n,2:n-1) &
     &                  +  v(2:n-1,1:n-2) + v(2:n-1,3:n))*4.d0 &
     &                  +  v(1:n-2,1:n-2) + v(3:n,1:n-2) &
     &                  +  v(1:n-2,3:n) + v(3:n,3:n))/20.0d0
         error = normError(u-v)
      end do

      call cpu_time(finish)

      print*,"Fortran Solution of Laplace Equation: (vectorization)", n
      print*,"    Number of iterations: ", count
      print*,"    Error: ", error
      print '("     Time: ",f6.3," seconds.")',finish-start

!----------------------------------------------------------------------
      contains
!----------------------------------------------------------------------
         function normError(w)
         real*8 w(n,n)
         integer i,j
         real*8 normError, err
         err = 0.00
         do j=2,n-1
            do i=2,n-1
               err = err + w(i,j)*w(i,j)
            end do
         end do

         normError = sqrt(err)
         end function normError

      end program laplaceJacobi4_vect
