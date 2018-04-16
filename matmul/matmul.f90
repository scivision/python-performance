Program run_matmul

  use, intrinsic :: iso_fortran_env, only : sp=>REAL32,dp=>REAL64, INT64, stdout=>output_unit, &
        compiler_version, compiler_options
  use perf, only : init_random_seed, sysclock2ms

  Implicit None

  integer,parameter :: wp=dp
  integer :: N, Nrun, ios
  character(16) :: argv
  real(wp) :: tdmatmul,tsmatmul,tdblint, tsglint
  
  print *,compiler_version()
  print *,compiler_options()

  N=1000
  call get_command_argument(1,argv,status=ios); if(ios==0) read(argv,*) N

  Nrun=5
  call get_command_argument(2,argv,status=ios); if(ios==0) read(argv,*) Nrun

  tdmatmul = double_gemm(N,Nrun)
  tsmatmul = single_gemm(N,Nrun)
  tdblint = double_matmul(N,Nrun)
  tsglint = single_matmul(N,Nrun)

  print *,''
  print '(A25,F10.6)', 'double DGEMM (sec): ',tdmatmul
  print '(A25,F10.6)', 'single SGEMM (sec): ',tsmatmul
  print '(A25,F10.6)', 'double intrinsic (sec): ',tdblint
  print '(A25,F10.6)', 'single intrinsic (sec): ',tsglint

contains

Real(wp) Function double_gemm(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(dp), dimension(N,N) :: A, B, D
    integer :: k
    integer(int64) :: tic,toc,tmin=huge(0_int64)  ! MUST BE _int64!!!

    D(:,:) = 0. ! cannot initialize automatic array directly

    call init_random_seed()
! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming double-prec. DGEMM loop'
    ! recommended to call once before loop per Intel manual
    call dgemm('N','N',N,N,N,1._dp,A,N,B,N,0._dp,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)

        call system_clock(tic)
        call dgemm('N','N',N,N,N,1._dp,A,N,B,N,0._dp,D,N) !ifort 14 10% faster than gfortran 5
        call system_clock(toc)

        if (toc-tic < tmin) tmin=toc-tic

        if (modulo(k,1) == 0) then
            write(stdout,'(F6.1,A1)', advance='no') real(k,wp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    double_gemm = sysclock2ms(tmin) / 1000.

end function double_gemm


Real(wp) function single_gemm(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(sp),dimension(N,N) :: A, B, D

    integer :: k
    integer(int64) :: tic,toc, tmin=huge(0_int64)

    D(:,:) = 0.

    call init_random_seed()

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming single-prec. SGEMM loop'
    ! recommended to call once before loop per Intel manual
    call sgemm('N','N',N,N,N,1._sp,A,N,B,N,0._sp,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)

        call system_clock(tic)
        call sgemm('N','N',N,N,N,1_sp,A,N,B,N,0_sp,D,N)
        call system_clock(toc)

        if (toc-tic < tmin) tmin=toc-tic

        if (modulo(k,1) == 0) then
            write(stdout,'(F6.1,A1)', advance='no') real(k,wp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    single_gemm = sysclock2ms(tmin) / 1000.

end function single_gemm


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
    D = matmul(A,B)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)

        call system_clock(tic)
        D = matmul(A,B)
        call system_clock(toc)

        if (toc-tic < tmin) tmin=toc-tic

        if (modulo(k,1) == 0) then
            write(stdout,'(F6.1,A1)', advance='no') real(k,wp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    double_matmul = sysclock2ms(tmin) / 1000.

end function double_matmul


Real(wp) Function single_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(sp), dimension(N,N) :: A, B, D
    integer :: k
    integer(int64) :: tic,toc,tmin=huge(0_int64)  ! MUST BE _int64!!!

    D(:,:) = 0. ! cannot initialize automatic array directly

    call init_random_seed()
! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming single-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    D = matmul(A,B)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)

        call system_clock(tic)
        D = matmul(A,B)
        call system_clock(toc)

        if (toc-tic < tmin) tmin=toc-tic

        if (modulo(k,1) == 0) then
            write(stdout,'(F6.1,A1)', advance='no') real(k,wp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    single_matmul = sysclock2ms(tmin) / 1000.

end function single_matmul

End Program
