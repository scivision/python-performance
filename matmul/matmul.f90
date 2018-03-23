Program run_matmul

  use, intrinsic :: iso_fortran_env, only : sp=>REAL32,dp=>REAL64, INT64, stdout=>output_unit, &
        compiler_version, compiler_options
  use perf, only : init_random_seed, sysclock2ms

  Implicit None

  integer,parameter :: wp=dp
  integer :: N, Nrun, ios
  character(16) :: argv
  real(wp) :: tdmatmul,tsmatmul
  
  print *,compiler_version()
  print *,compiler_options()

  N=1000
  call get_command_argument(1,argv,status=ios); if(ios==0) read(argv,*) N

  Nrun=5
  call get_command_argument(2,argv,status=ios); if(ios==0) read(argv,*) Nrun

  tdmatmul = double_matmul(N,Nrun)
  tsmatmul = single_matmul(N,Nrun)

  print *,''
  print '(A20,F10.6)', 'double matmul (sec): ',tdmatmul
  print '(A20,F10.6)', 'single matmul (sec): ',tsmatmul

contains

Real(wp) Function double_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(dp), dimension(N,N) :: A, B, D
    integer :: k
    integer(int64) :: tic,toc,tmin=huge(0_int64)  ! MUST BE _int64!!!

    D(:,:) = 0. ! cannot initialize automatic array directly

    call init_random_seed()
! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming double-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call dgemm('N','N',N,N,N,1._dp,A,N,B,N,0._dp,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)

        call system_clock(tic)
        call dgemm('N','N',N,N,N,1._dp,A,N,B,N,0._dp,D,N) !ifort 14 10% faster than gfortran 5
        !D = matmul(A,B)
        call system_clock(toc)

        if (toc-tic < tmin) tmin=toc-tic

        if (modulo(k,1) == 0) then
            write(stdout,'(F6.1,A1)', advance='no') real(k,wp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    double_matmul = sysclock2ms(tmin) / 1000.
!    print *,''
!    print '(A,F10.3)', 'fortran real64 ms / iteration: ', double_matmul

end function double_matmul



Real(wp) function single_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(sp),dimension(N,N) :: A, B, D

    integer :: k
    integer(int64) :: tic,toc, tmin=huge(0_int64)

    D(:,:) = 0.

    call init_random_seed()

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming single-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call sgemm('N','N',N,N,N,1._sp,A,N,B,N,0._sp,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)

        call system_clock(tic)
        call sgemm('N','N',N,N,N,1_sp,A,N,B,N,0_sp,D,N)  !single prec only
        !D = matmul(A,B)
        call system_clock(toc)

        if (toc-tic < tmin) tmin=toc-tic

        if (modulo(k,1) == 0) then
            write(stdout,'(F6.1,A1)', advance='no') real(k,wp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    single_matmul = sysclock2ms(tmin) / 1000.

    !print *,''
    !print '(A,F10.3)', 'fortran real32 ms / iteration: ', single_matmul

end function single_matmul

End Program
