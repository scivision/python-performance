module benchmark_hypot
    use, intrinsic :: iso_fortran_env, only : dp=>REAL64,INT64
    use perf, only : init_random_seed,sysclock2ms
    Implicit None
contains

real(dp) function benchhypot()
    integer :: i
    integer(int64) :: tic,toc,tmin1=huge(0_int64),tmin2=huge(0_int64)

    integer,parameter :: N=10000,Nrun=10000
    real(dp),allocatable :: A(:),B(:)

    real(dp) :: Rhypot(Nrun)
    real(dp) :: Thypot,Trsq
    ! volatile tells compiler that value is unpredictable, don't unroll, etc.
    real(dp),volatile :: C(N),D(N)

    allocate(A(N),B(N))
    call init_random_seed()


! priming
       call system_clock(tic)
            C = hypot(A,B)
       call system_clock(toc)
!---------------  No need to loop arrays input into hypot or sqrt, this is F2008 after all!
    do i = 1, Nrun
       call random_number(A)
       call random_number(B)

       call system_clock(tic)
       C = hypot(A,B)
       call system_clock(toc)
       if (toc-tic<tmin1) tmin1=toc-tic

   Thypot = sysclock2ms(tmin1)
!-----------
       call system_clock(tic)
       D = sqrt(A**2 + B**2)
       call system_clock(toc)
       if (toc-tic<tmin2) tmin2=toc-tic

    Trsq = sysclock2ms(tmin2)

    Rhypot(i) = Trsq/Thypot

    enddo !i

benchhypot = sum(Rhypot)/real(Nrun, dp)


end Function benchhypot

end module benchmark_hypot

