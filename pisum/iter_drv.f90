Program run_iter

    use, intrinsic :: iso_fortran_env, only : dp=>REAL64
    use benchmark_iter,only : simple_iter,mandeltest, pisum

    Implicit None

    integer,parameter :: Nmand=5
    integer,parameter :: Niter=1000000, Nruniter=100,Nrunmand=1000

    real(dp) :: t

    print *, '--> FORTRAN'
!-----simple_iter----------------------
    t = simple_iter(Niter,Nruniter)
    print *, 'Iteration (millisec): ',t
!------mandlebrot-------------
    t = mandeltest(Nmand,Nrunmand)
    print *, 'Mandelbrot (millisec): ',t
!------pisum----------------
    t = pisum(Niter,Nruniter)
    print *, 'pisum (millisec): ',t


End Program