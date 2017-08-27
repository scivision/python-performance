Program run_iter

    use, intrinsic:: iso_fortran_env, only: dp=>real64, i64=>int64
    use benchmark_iter,only: simple_iter,mandeltest, pisum
    use perf, only: sysclock2ms

    Implicit None

    integer :: im
    integer(i64) :: tic,toc

    integer,parameter :: Nmand=5
    integer,parameter :: Niter=1000000, Nruniter=100,Nrunmand=1000
    
    character(*),parameter :: frmt = '(A20,F10.4)'

    real(dp) :: t

    im = this_image()

    if (im==1) then

      print *, '--> Fortran (times in milliseconds)'
!-----simple_iter----------------------
      t = simple_iter(Niter,Nruniter)
      print frmt, 'Iteration: ',t

    endif

!------mandlebrot-------------
    call system_clock(tic)
    t = mandeltest(Nmand,Nrunmand)
    call system_clock(toc)
    
    print frmt, 'Mandelbrot: ',t
    print '(A,I2,A,F8.3,A)','Total Mandelbrot time with ',num_images(),' images is ',sysclock2ms(toc-tic),' ms.'

!------pisum----------------
    call system_clock(tic)
    t = pisum(Niter/10,Nruniter)
    call system_clock(toc)

    print frmt, 'pisum: ',t
    print '(A,I2,A,F8.3,A)','Total pi time with ',num_images(),' images is ',sysclock2ms(toc-tic),' ms.'


End Program
