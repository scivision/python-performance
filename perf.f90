! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90
Module perf
    use, intrinsic :: iso_fortran_env, only : REAL64,INT64, stderr=>error_unit
    Implicit None
Contains

    real(REAL64) function sysclock2ms(t)
    ! Convert a number of clock ticks, as returned by system_clock called
    ! with integer(i64) arguments, to milliseconds
     
        integer(kind=INT64), intent(in) :: t
        integer(kind=INT64) :: rate
        real(kind=REAL64) ::  r
        call system_clock(count_rate=rate)
        r = 1000.d0 / rate
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

    subroutine assert(cond) 
        logical, intent(in) :: cond

        if (.not. cond) then
            write(stderr,*) 'assertion failed, halting test'
            stop
        end if

    end subroutine assert

End Module perf
