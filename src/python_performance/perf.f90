! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90
module perf

use, intrinsic :: iso_fortran_env, only : dp=>REAL64,INT64, stderr=>error_unit
implicit none (type, external)

contains

impure elemental real(dp) function sysclock2ms(t)
! Convert a number of clock ticks, as returned by system_clock called
! with integer(int64) arguments, to milliseconds

integer(int64), intent(in) :: t
integer(int64) :: rate
real(dp) ::  r
call system_clock(count_rate=rate)
r = 1000._dp / rate
sysclock2ms = t * r
end function sysclock2ms


end Module perf
