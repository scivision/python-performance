Program run_iter

  use, intrinsic:: iso_fortran_env, only: dp=>real64, i64=>int64, compiler_version, compiler_options
  use benchmark_iter,only: simple_iter,mandeltest, pisum
  use perf, only: sysclock2ms

  Implicit None

  integer,parameter :: Nmand=5,Nrunmand=1000
  integer :: N, Nrun, argc, Ni
  character(16) :: argv

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
  print '(A,I12,A,I3,A)', '--> Fortran.  N=',N,' using',Ni,' images'
  print *,compiler_version()
  print *,compiler_options()
!-----simple_iter----------------------
  t = simple_iter(N, Nrun)
  print '(A,ES12.4,A)', 'Iteration: ',t,' sec.'

!------mandlebrot-------------
  t = mandeltest(Nmand,Nrunmand)

  print '(A,ES12.4,A)', 'Mandelbrote:',t,' sec.'

!------pisum----------------
  t = pisum(N, Nrun)

  print  '(A,ES12.4,A)', 'pisum:',t,' sec.'


End Program
