! **********************************************************
! Given a nxnx3 matrix A, we want to perform the operations:
!
!       A[i][j][0] = A[i][j][1]
!       A[i][j][2] = A[i][j][0]
!       A[i][j][1] = A[i][j][2]
! **********************************************************
      program copyMatrix

      real :: r
      integer dim1, i, j, l
      double precision, ALLOCATABLE :: A(:, :, :)
!      real start, finish, tarray(2)
      real start1, finish1
      real start2, finish2
      CHARACTER(len=30) :: arg(1)

      !----------------------------------------
      ! Get the dimension from the command line
      !----------------------------------------
      call getarg(1,arg(1))
      read(arg(1), * ) dim1
     
      ALLOCATE( A(dim1, dim1, 3))

      !-----------------
      ! Loop formulation
      !-----------------
      call srand(86456)
      do i = 1, dim1
        do j = 1, dim1
           do l = 1, 3
              call random_number(r)
              A(i, j, l) = r
          enddo
        enddo
      enddo

      call cpu_time(start1)

      do j = 1, dim1
         do i = 1, dim1
            A(i, j, 1) = A(i,j,2)
            A(i, j, 3) = A(i,j,1)
            A(i, j, 2) = A(i,j,3)
         enddo
      enddo

      call cpu_time(finish1)
      print *,'Time Matrix Copy - ji loop: ', dim1, finish1-start1,' s'

      !--------------------------
      ! Vectorization formulation
      !--------------------------
      call srand(86456)
      do i = 1, dim1
        do j = 1, dim1
           do l = 1, 3
              call random_number(r)
              A(i, j, l) = r
          enddo
        enddo
      enddo

      call cpu_time(start2)

      A(:,:,1) = A(:,:,2)
      A(:,:,3) = A(:,:,1)
      A(:,:,2) = A(:,:,3)

      call cpu_time(finish2)
      print *,'Time Matrix Copy - vectorization ', dim1, finish2 - start2,' s'

      end program copyMatrix
