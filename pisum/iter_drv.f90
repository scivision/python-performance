Program run_iter

    use, intrinsic :: iso_fortran_env, only : dp=>real64
    use benchmark_iter,only : simple_iter,mandeltest, pisum

    Implicit None

    integer,parameter :: Nmand=5
    integer,parameter :: Niter=1000000, Nruniter=100,Nrunmand=1000
    
    character(*),parameter :: frmt = '(A20,F10.4)'

    real(dp) :: t

    print *, '--> Fortran (times in milliseconds)'
!-----simple_iter----------------------
    t = simple_iter(Niter,Nruniter)
    print frmt, 'Iteration: ',t
!------mandlebrot-------------
    t = mandeltest(Nmand,Nrunmand)
    print frmt, 'Mandelbrot: ',t
!------pisum----------------
    t = pisum(Niter/10,Nruniter)
    print frmt, 'pisum: ',t


End Program
