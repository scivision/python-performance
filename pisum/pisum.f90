Program run_iter

  use, intrinsic:: iso_fortran_env, only: dp=>real64, i64=>int64
  use benchmark_iter,only: simple_iter,mandeltest, pisum
  use perf, only: sysclock2ms

  Implicit None

  integer(i64) :: tic,toc

  integer,parameter :: Nmand=5,Nrunmand=1000
  integer :: N, Nrun, argc, Ni
  character(16) :: argv

  character(*),parameter :: frmt = '(A20,F10.4)'

  real(dp) :: t
  
!  Ni = num_images()
  Ni=1

  argc = command_argument_count()
  if (argc>0) then
    call get_command_argument(1,argv)
    read(argv,*) N
  else
    N = 100000
  endif

  if (argc>1) then
    call get_command_argument(2,argv)
    read(argv,*) Nrun
  else
    Nrun = 10
  endif
!-----------------------------------------------------
  print '(A,I12)', '--> Fortran (times in milliseconds)  N=',N
!-----simple_iter----------------------
  t = simple_iter(N, Nrun)
  print frmt, 'Iteration: ',t


!------mandlebrot-------------
  call system_clock(tic)
  t = mandeltest(Nmand,Nrunmand)
  call system_clock(toc)

  print frmt, 'Mandelbrot: ',t
  print '(A,I2,A,F8.3,A)','Total Mandelbrot time with ',Ni,' images is ',sysclock2ms(toc-tic),' ms.'

!------pisum----------------
  call system_clock(tic)
  t = pisum(N/10, Nrun)
  call system_clock(toc)

  print frmt, 'pisum: ',t
  print '(A,I2,A,F8.3,A)','Total pi time with ',Ni,' images is ',sysclock2ms(toc-tic),' ms.'


End Program
