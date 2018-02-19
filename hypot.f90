Program run_hypot

  use, intrinsic :: iso_fortran_env, only : dp=>REAL64,INT64
  use perf, only : init_random_seed,sysclock2ms
  Implicit None

  integer, parameter :: wp=dp
  integer :: argc, N, Nrun
  character(16) :: argv
  real(wp) :: Rhypot

  argc = command_argument_count()
  if (argc>0) then
    call get_command_argument(1,argv)
    read(argv,*) N
  else 
    N = 1000
  endif

  if (argc>1) then
    call get_command_argument(2,argv)
    read(argv,*) Nrun
  else
    Nrun = 10
  endif

  Rhypot = benchhypot(N,Nrun)

  print '(A,I10,A,F7.5)', 'sqrt(a^2+b^2) / hypot(a,b).  N=',N,'  time ratio: ',Rhypot

contains

real(wp) function benchhypot(N,Nrun)
  integer :: i
  integer(int64) :: tic,toc,tmin1,tmin2

  integer,intent(in) :: N, Nrun
  real(wp) :: A(N), B(N), Rhypot(Nrun), Thypot,Trsq
  ! volatile tells compiler that value is unpredictable, don't unroll, etc.
  real(wp),volatile :: C(N),D(N)

  tmin1=huge(0_int64)
  tmin2=huge(0_int64)

  call init_random_seed()


! priming
  call system_clock(tic)
    C = hypot(A,B)
  call system_clock(toc)

  main: do i = 1, Nrun
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

  enddo main

  benchhypot = sum(Rhypot)/real(Nrun, wp)

end function benchhypot

End Program
