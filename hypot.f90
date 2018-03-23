Program run_hypot

  use, intrinsic :: iso_fortran_env, only : wp=>REAL64,INT64
  use perf, only : init_random_seed,sysclock2ms
  Implicit None

  integer :: N, Nrun, ios
  character(16) :: argv
  real(wp) :: Rhypot

  call init_random_seed()

  N = 1000
  call get_command_argument(1,argv, status=ios); if(ios==0) read(argv,*) N

  Nrun = 10
  call get_command_argument(2,argv, status=ios); if(ios==0) read(argv,*) Nrun

  Rhypot = benchhypot(N,Nrun)

  print '(A,I10,A,F7.5)', 'sqrt(a**2 + b**2) / hypot(a,b).  N=',N,'  time ratio: ',Rhypot
  
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

    Rhypot(i) = Trsq / Thypot

  enddo main

  benchhypot = sum(Rhypot) / Nrun

end function benchhypot

End Program
