module benchmark_iter

  use, intrinsic :: iso_fortran_env, only : dp=>real64,i64=>int64, stderr=>error_unit
  use perf, only : init_random_seed, sysclock2ms, assert
  Implicit None
  integer, parameter :: wp=dp

contains


Real(dp) function pisum(N,Nrun) result(t)

integer, intent(in) :: N,Nrun

integer(i64) :: tic,toc,tmin
!   integer(i64) :: tmin[*] = huge(0_i64)
!    real(wp) :: psum[*] = 0._wp
integer :: k,j, im, Nimg
real(wp), parameter :: pi = 4.0_wp*atan(1.0_wp)
real(wp) :: psum

tmin = huge(0_i64)

!im = this_image()
!Nimg = num_images()
im=1
Nimg= 1

do j = 1,Nrun

  call system_clock(tic)
  psum = 0._wp ! must have this line
  do k = im,N, Nimg   ! 1,N
    psum = psum + (-1.0_wp)**(real(k,wp)+1.0_wp) / (2.0_wp*k - 1.0_wp)
  enddo
!       call co_sum(psum)
  call system_clock(toc)
  if (toc-tic<tmin) tmin=toc-tic

enddo

!   if (im==1) then
psum = 4._wp*psum

if (abs(psum-pi) > 1e-4_wp) then
  write(stderr,*) 'final value',psum
  write(stderr,*) 'error ', psum - pi
  error stop 'FORTRAN pisum fail to converge'
endif

!    endif

!  call co_min(tmin)

t = sysclock2ms(tmin) / 1000

End Function pisum

end module benchmark_iter


Program run_iter

  use, intrinsic:: iso_fortran_env, only: dp=>real64, i64=>int64, compiler_version, compiler_options
  use benchmark_iter,only: pisum
  use perf, only: sysclock2ms

  Implicit None

  integer :: N=100000, Nrun=10, argc, Ni
  character(16) :: argv

  real(dp) :: t
  
!  Ni = num_images()
  Ni=1

  argc = command_argument_count()
  if (argc>0) then
    call get_command_argument(1,argv)
    read(argv,*) N
  endif

  if (argc>1) then
    call get_command_argument(2,argv)
    read(argv,*) Nrun
  endif
!-----------------------------------------------------
  print '(A,I12,A,I3,A)', '--> Fortran.  N=',N,' using',Ni,' images'
  print *,compiler_version()
  print *,compiler_options()

!------pisum----------------
  t = pisum(N, Nrun)

  print  '(A,ES12.4,A)', 'pisum:',t,' sec.'


End Program
