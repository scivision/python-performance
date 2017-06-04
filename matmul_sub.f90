module benchmark_matmul
! https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines
! https://software.intel.com/en-us/mkl-developer-reference-fortran-gemm
    !use blas95, only: gemm
    use, intrinsic :: iso_fortran_env, only : REAL32,REAL64,INT64, stdout=>output_unit
    use perf, only : init_random_seed, sysclock2ms 
    Implicit None
    
contains

!TODO upgrade to polymorphic

Real(real64) Function double_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(real64),allocatable :: A(:,:), B(:,:), D(:,:)

    integer :: k
    integer(int64) :: tic,toc,tmin=huge(0_int64)  ! MUST BE _int64!!!

    allocate(A(N,N))
    allocate(B,mold=A)
    allocate(D,mold=A)
    D=0.d0 ! cannot initialize automatic array directly

    call init_random_seed()
! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming double-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call dgemm('N','N',N,N,N,1.d0,A,N,B,N,1.d0,D,N)
    !call gemm(A,B,D)

    do K = 1,nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)
        
        call system_clock(tic)
        
        call dgemm('N','N',N,N,N,1.d0,A,N,B,N,1.d0,D,N)
        !call gemm(A,B,D)
        !D = matmul(A,B) !4-5 times slower with ifort 14 than gfortran 5!
        call system_clock(toc)
        
        if (toc-tic < tmin) tmin = toc-tic
       
        if (mod(k,1) == 0) then 
            write(stdout,'(F6.1,A1)', advance='no') real(k)/Nrun*100.,'% done'
            flush(stdout)
        endif
    end do

    double_matmul=sysclock2ms(tmin)
    print *,''
    print '(A,F10.3)', 'fortran real64 ms / iteration: ', double_matmul

end function double_matmul



Real(real64) function single_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(real32),allocatable :: A(:,:),B(:,:),D(:,:)

    integer :: k
    integer(int64) :: tic,toc, tmin=huge(0_int64)

    allocate(A(N,N))
    allocate(B,mold=A)
    allocate(D,mold=A)
    D=0.0 

    call init_random_seed()

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming single-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call sgemm('N','N',N,N,N,1.0,A,N,B,N,1.0,D,N)
    !call gemm(A,B,D)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)
        
        call system_clock(tic)
        call sgemm('N','N',N,N,N,1.0,A,N,B,N,1.0,D,N)  !single prec only
        !call gemm(A,B,D)
        !D = matmul(A,B)
        call system_clock(toc)
        
        if (toc-tic < tmin) tmin=toc-tic
       
        if (mod(k,1) == 0) then 
            write(stdout,'(F6.1,A1)', advance='no') real(k)/Nrun*100.,'% done'
            flush(stdout)
        endif
    end do

    single_matmul=sysclock2ms(tmin)

    print *,''
    print '(A,F10.3)', 'fortran real32 ms / iteration: ', single_matmul

end function single_matmul

end module benchmark_matmul
