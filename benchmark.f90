program benchrandmult
    Implicit None
    
    integer, parameter ::  dp = kind(0.d0)
    integer, parameter :: i64 = selected_int_kind(18) ! At least 64-bit integer
    
    real(dp) :: sysclock2ms
    integer :: k
    integer(i64) :: tic,toc,tmin
    
    integer,parameter :: N=5000
    real(dp) :: A(N,N), B(N,N),y(N,N)

    Integer, parameter :: Nrun=10    

!    print *,'init random seed'
    call init_random_seed()
!    print *,'fill matrices'
    call random_number(A)

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'start loop'
    do k = 1, Nrun
        call system_clock(tic)
        y = matmul(A,B)
        call system_clock(toc)
        if (toc-tic<tmin) tmin=toc-tic
        print *,real(k)/Nrun*100.
    end do

    tmin = toc-tic

print "('fortran seconds per matmul',f0.3)", sysclock2ms(tmin) /1000.

end program

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

! Convert a number of clock ticks, as returned by system_clock called
! with integer(i64) arguments, to milliseconds
function sysclock2ms(t)
    integer, parameter ::  dp = kind(0.d0)
    integer, parameter :: i64 = selected_int_kind(18) ! At least 64-bit integer
    
  integer(i64), intent(in) :: t
  integer(i64) :: rate
  real(dp) ::  sysclock2ms,r
  call system_clock(count_rate=rate)
  r = 1000._dp / rate
  sysclock2ms = t * r
end function sysclock2ms

subroutine init_random_seed()
integer :: i, n, clock
integer, allocatable :: seed(:)
call random_seed(size=n)
allocate(seed(n))
call system_clock(count=clock)
seed = clock + 37 * [ (i - 1, i = 1, n) ]
call random_seed(put=seed)
end subroutine
