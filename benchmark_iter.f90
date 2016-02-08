program benchiter
Implicit None

    integer, parameter ::  dp = kind(0.d0)
    integer, parameter :: i64 = selected_int_kind(18) 
    
    real(dp) :: sysclock2ms
    integer :: i,j
    integer(i64) :: tic,toc,tmin=huge(0)
    
    integer,parameter :: N=1000000, Nrun=1000
    real(dp) :: A(N), x

   call init_random_seed()
   call random_number(A)
   
   
   Do j = 1, Nrun
       call system_clock(tic)
       x = 0
       Do i = 1, N
        
        x = 0.5*x + mod(A(i),10.)
        if (x>huge(0)) exit !to defeat loop unrolling
       
       End Do   
       call system_clock(toc)
       if (toc-tic<tmin) tmin=toc-tic 
       
   End Do

   
  print "('fortran millisec per iteration ',f11.7)", sysclock2ms(tmin)

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
