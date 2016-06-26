module benchmark_iter
    use, intrinsic :: iso_fortran_env, only : dp=>REAL64,i64=>INT64
    use perf, only : init_random_seed, sysclock2ms, assert
    Implicit None
contains
!----------------- mandelbrot -------------------------------
integer function mandel(z0) result(r)
    complex(dp), intent(in) :: z0
    complex(dp) :: c, z
    integer :: n, maxiter
    maxiter = 80
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
    integer, intent(in) :: N,Nrun
    integer(i64) :: tic,toc,tmin = huge(0_i64)
    integer :: i,k,f=0

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
    integer :: j,i
    integer(i64) :: tic,toc,tmin=huge(0_i64)

    integer,Intent(in) :: N,Nrun
    real(dp) :: A(N)
    ! volatile tells compiler that value is unpredictable, don't unroll, etc.
    real(dp), volatile ::x

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

end Function simple_iter

end module benchmark_iter

