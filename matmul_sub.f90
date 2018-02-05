module benchmark_matmul
! https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines
! https://software.intel.com/en-us/mkl-developer-reference-fortran-gemm

    use, intrinsic :: iso_fortran_env, only : sp=>REAL32,dp=>REAL64,INT64, stdout=>output_unit
    use perf, only : init_random_seed, sysclock2ms 
    Implicit None
    
contains

!TODO upgrade to polymorphic

Real(dp) Function double_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(dp), dimension(N,N) :: A, B, D

    integer :: k
    integer(int64) :: tic,toc,tmin=huge(0_int64)  ! MUST BE _int64!!!

    D(:,:) = 0._dp ! cannot initialize automatic array directly

    call init_random_seed()
! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming double-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call dgemm('N','N',N,N,N,1_dp,A,N,B,N,0_dp,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)
        
        call system_clock(tic)
        call dgemm('N','N',N,N,N,1_dp,A,N,B,N,0_dp,D,N) !ifort 14 10% faster than gfortran 5
        !D = matmul(A,B) 
        call system_clock(toc)
        
        if (toc-tic < tmin) tmin=toc-tic
       
        if (mod(k,1) == 0) then 
            write(stdout,'(F6.1,A1)', advance='no') real(k,dp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    double_matmul=sysclock2ms(tmin)
    print *,''
    print '(A,F10.3)', 'fortran real64 ms / iteration: ', double_matmul

end function double_matmul



Real(dp) function single_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(sp),dimension(N,N) :: A, B, D

    integer :: k
    integer(int64) :: tic,toc, tmin=huge(0_int64)

    D(:,:) = 0_sp 

    call init_random_seed()

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming single-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call sgemm('N','N',N,N,N,1_sp,A,N,B,N,0_sp,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)
        
        call system_clock(tic)
        call sgemm('N','N',N,N,N,1_sp,A,N,B,N,0_sp,D,N)  !single prec only
        !D = matmul(A,B) 
        call system_clock(toc)
        
        if (toc-tic < tmin) tmin=toc-tic
       
        if (mod(k,1) == 0) then 
            write(stdout,'(F6.1,A1)', advance='no') real(k,dp)/Nrun*100,'% done'
            flush(stdout)
        endif
    end do

    single_matmul=sysclock2ms(tmin)

    print *,''
    print '(A,F10.3)', 'fortran real32 ms / iteration: ', single_matmul

end function single_matmul

end module benchmark_matmul
