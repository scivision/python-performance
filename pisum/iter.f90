module benchmark_iter

  use, intrinsic :: iso_fortran_env, only : dp=>real64,i64=>int64, stderr=>error_unit
  use perf, only : init_random_seed, sysclock2ms, assert
  Implicit None
  integer, parameter :: wp=dp

contains
!----------------- mandelbrot -------------------------------
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


!------------ end mandlebrot ------------------------------

Real(dp) function simple_iter(N,Nrun) result(t)

  integer,Intent(in) :: N,Nrun

  integer :: j,i
  integer(i64) :: tic,toc,tmin
  real(wp) :: A(N)
  ! volatile tells compiler that value is unpredictable, don't unroll, etc.
  real(wp), volatile :: x
  
  tmin = huge(0_i64)

  call init_random_seed()


  Do j = 1, Nrun
    call random_number(A)
    call system_clock(tic)
    x = 0._wp
    Do i = 1, N
      x = 0.5_wp*x + modulo(A(i), 10._wp)
    End Do
    call system_clock(toc)
    if (toc-tic<tmin) tmin=toc-tic
  End Do

  t = sysclock2ms(tmin) / 1000

End Function simple_iter


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

