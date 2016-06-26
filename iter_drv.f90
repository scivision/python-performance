Program run_iter

    use, intrinsic :: iso_fortran_env, only : dp=>REAL64
    use benchmark_iter,only : simple_iter,mandeltest

    Implicit None

    integer,parameter :: Nmand=5
    integer,parameter :: Niter=1000000, Nruniter=100,Nrunmand=1000

    real(dp) :: titer,tmandel

    titer = simple_iter(Niter,Nruniter)
!------mandlebrot-------------
    tmandel=mandeltest(Nmand,Nrunmand)

     print *, 'Iteration (millisec): ',titer
     print *, 'Mandelbrot (millisec): ',tmandel / Nruniter

End Program