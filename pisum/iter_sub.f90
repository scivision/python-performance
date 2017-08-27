module benchmark_iter

    use, intrinsic :: iso_fortran_env, only : dp=>real64,i64=>int64, stderr=>error_unit
    use perf, only : init_random_seed, sysclock2ms, assert
    Implicit None

contains
!----------------- mandelbrot -------------------------------
elemental integer function mandel(z0) result(r)

    complex(dp), intent(in) :: z0
    complex(dp) :: c, z
    integer :: n
    integer, parameter :: maxiter = 80

    z = z0
    c = z0
    do n = 1, maxiter
        if (abs(z) > 2) then
            r = n-1
            return
        end if
        z = z**2 + c
    end do
    r = maxiter

end function mandel


elemental integer function mandelperf() result(mandel_sum)

    integer :: re, im
    volatile :: mandel_sum

    mandel_sum = 0

    do re=-20,5
      do im = -10,10
        mandel_sum = mandel_sum + mandel(cmplx(re/10.0_dp, im/10.0_dp, dp))
      end do
    end do

end function mandelperf


Real(dp) function mandeltest(N,Nrun)
    integer, intent(in) :: N,Nrun
    integer(i64) :: tic,toc,tmin
    integer :: i,k,f
    f = 0
    tmin = huge(0_i64)

    do i = 1, Nrun
        call system_clock(tic)
        do k = 1, N
            f = mandelperf()
        end do
        call system_clock(toc)
        if (toc-tic < tmin) tmin = toc-tic
    end do

    call assert(f == 14791)
    mandeltest = sysclock2ms(tmin)

end function mandeltest


!------------ end mandlebrot ------------------------------

Real(dp) function simple_iter(N,Nrun)

    integer,Intent(in) :: N,Nrun

    integer :: j,i
    integer(i64) :: tic,toc,tmin
    real(dp) :: A(N)
    ! volatile tells compiler that value is unpredictable, don't unroll, etc.
    real(dp), volatile :: x

    tmin = huge(0_i64)

   call init_random_seed()


   Do j = 1, Nrun
       call random_number(A)
       call system_clock(tic)
       x = 0.0_dp
       Do i = 1, N
          x = 0.5_dp*x + mod(A(i),10._dp)
       End Do
       call system_clock(toc)
       if (toc-tic<tmin) tmin=toc-tic
   End Do

    simple_iter = sysclock2ms(tmin)

End Function simple_iter

Real(dp) function pisum(N,Nrun)
    integer,Intent(in) :: N,Nrun

    integer(i64) :: tic,toc,tmin
    real(dp) :: psum[*] = 0.0_dp
    integer :: k,j, im, Nimg
    real(dp),parameter :: pi = 4.0_dp*atan(1.0_dp)

    tmin = huge(0_i64)

    im = this_image()
    Nimg = num_images()

    do j = im,Nrun, Nimg   ! 1,Nrun
        call system_clock(tic)
        psum = 0.0_dp
        do k = 1,N
            psum = psum + (-1.0_dp)**(real(k,dp)+1.0_dp)/(2.0_dp*k-1.0_dp)
        enddo
        call co_sum(psum)
        call system_clock(toc)
        if (toc-tic<tmin) tmin=toc-tic
    End Do

    psum = 4.0_dp*psum
    print *, psum

    if (abs(psum-pi) > 1e-4_dp) then
        write(stderr,*) 'final value',psum
        write(stderr,*) 'error ', psum - pi
        error stop 'FORTRAN pisum fail to converge'
    endif

    pisum = sysclock2ms(tmin)

End Function pisum

end module benchmark_iter

