module benchmark_iter
    use, intrinsic :: iso_fortran_env, only : dp=>REAL64,i64=>INT64
    use perf, only : init_random_seed, sysclock2ms, assert
    Implicit None
contains
!----------------- mandelbrot -------------------------------
integer function mandel(z0) result(r)
    implicit none
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

integer function mandelperf() result(mandel_sum)
    implicit none
    integer :: re, im
    volatile :: mandel_sum
    mandel_sum = 0
    re = -20
    do while (re <= 5)
        im = -10
        do while (im <= 10)
            mandel_sum = mandel_sum + mandel(cmplx(re/10._dp, im/10._dp, dp))
            im = im + 1
        end do
        re = re + 1
    end do
end function mandelperf

Real(dp) function mandeltest(N,Nrun)
    implicit none
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
    implicit none
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
       x = 0.d0
       Do i = 1, N
          x = 0.5*x + mod(A(i),10._dp)
       End Do
       call system_clock(toc)
       if (toc-tic<tmin) tmin=toc-tic
   End Do

    simple_iter = sysclock2ms(tmin)

End Function simple_iter

Real(dp) function pisum(N,Nrun)
    implicit none
    integer,Intent(in) :: N,Nrun

    integer(i64) :: tic,toc,tmin
    real(dp), volatile :: s
    integer :: k,j
    real(dp),parameter :: pi = 4*atan(1.)

    tmin = huge(0_i64)

    Do j = 1,Nrun
        call system_clock(tic)
        s = 0.
        do k = 1,N
            s = s + (-1.)**(k+1)/(2*k-1)
        enddo
        call system_clock(toc)
        if (toc-tic<tmin) tmin=toc-tic
    End Do

    s=4*s

    if (abs(s-pi) .gt. 1e-4) then
        print *, 'final value',s
        print *, 'error mag ',abs(s-pi)
        error stop 'FORTRAN pisum fail to converge'
    endif

    pisum = sysclock2ms(tmin)

End Function pisum

end module benchmark_iter

