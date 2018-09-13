module siter

use, intrinsic :: iso_fortran_env, only : dp=>real64,i64=>int64, stderr=>error_unit
use perf, only: sysclock2ms, assert
Implicit None
integer, parameter :: wp=dp

contains

Real(dp) function simple_iter(N,Nrun) result(t)

integer,Intent(in) :: N,Nrun

integer :: j,i
integer(i64) :: tic,toc,tmin
real(wp) :: A(N)
! volatile tells compiler that value is unpredictable, don't unroll, etc.
real(wp), volatile :: x

tmin = huge(0_i64)

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

end module siter


program s

use siter, only: simple_iter, dp
use perf, only : init_random_seed
implicit none


integer :: N=100000, Nrun=10, argc
character(16) :: argv

real(dp) :: t

call init_random_seed()


argc = command_argument_count()
if (argc>0) then
  call get_command_argument(1,argv)
  read(argv,*) N
endif

if (argc>1) then
  call get_command_argument(2,argv)
  read(argv,*) Nrun
endif

t = simple_iter(N, Nrun)
print '(A,ES12.4,A)', 'Iteration: ',t,' sec.'


end program
