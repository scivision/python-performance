module mandelbrot

use, intrinsic :: iso_fortran_env, only : dp=>real64,i64=>int64, stderr=>error_unit
use perf, only: sysclock2ms, assert
Implicit None
integer, parameter :: wp=dp

contains

elemental integer function mandel(z0) result(r)

  complex(wp), intent(in) :: z0
  complex(wp) :: c, z
  integer :: n
  integer, parameter :: maxiter = 80

  z = z0
  c = z0
  
  do n = 1, maxiter
    if (abs(z) > 2) then
      r = n-1
      return
    end if
    z = z**2 + c
  end do
    
  r = maxiter

end function mandel


pure integer function mandelperf() result(mandel_sum)

  integer :: re, im, img, Nimg,msum
  !integer :: msum[*] = 0

  mandel_sum = 0
  msum=0 ! must have this line!

!   img = this_image()
!   Nimg = num_images()
  Nimg=1
  img=1

  do re=img-21, 5, Nimg !re=-20,5
    do im = -10,10
      msum = msum + mandel(cmplx(re/10.0_wp, im/10.0_wp, wp))
    end do
  end do

!  call co_sum(msum)

  mandel_sum = msum

end function mandelperf


Real(dp) function mandeltest(N,Nrun) result(t)
  integer, intent(in) :: N,Nrun
  integer(i64) :: tic,toc,tmin
  integer :: i,k,f
  f = 0
  tmin = huge(0_i64)

  do i = 1, Nrun
    call system_clock(tic)
    do k = 1, N
      f = mandelperf()
    end do
    call system_clock(toc)
    if (toc-tic < tmin) tmin = toc-tic
  end do

  call assert(f == 14791)
  
  t = sysclock2ms(tmin) / 1000

end function mandeltest

end module mandelbrot


program m

use mandelbrot, only: mandeltest, dp
implicit none

integer :: N=1000, Nrun=10, argc, Ni
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

t = mandeltest(N,Nrun)

print '(A,ES12.4,A)', 'Mandelbrot:',t,' sec.'


end program
