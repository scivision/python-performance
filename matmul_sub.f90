module benchmark_matmul
    use, intrinsic :: iso_fortran_env, only : sp=>REAL32,dp=>REAL64,i64=>INT64
    use perf, only : init_random_seed, sysclock2ms 
    Implicit None
    
contains

!TODO upgrade to polymorphic

Real(dp) Function double_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(dp),allocatable :: A(:,:),B(:,:),D(:,:)

    integer :: k
    integer(i64) :: tic,toc,tmin=huge(0)

    allocate(A(N,N))
    allocate(B(N,N),mold=A)
    allocate(D(N,N),mold=A)
    D=0.d0 ! cannot initialize automatic array directly

    call init_random_seed()

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming double-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call dgemm('N','N',N,N,N,1.d0,A,N,B,N,1.d0,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)
        
        call system_clock(tic)
        call dgemm('N','N',N,N,N,1.d0,A,N,B,N,1.d0,D,N) !ifort 14 10% faster than gfortran 5
        !D = matmul(A,B) !4-5 times slower with ifort 14 than gfortran 5!
        call system_clock(toc)
        
        if (toc-tic<tmin) tmin=toc-tic
       
        if (mod(k,1).eq.0) write(*,'(F5.1,A10)') real(k)/Nrun*100.,'% done'
    end do

    double_matmul=sysclock2ms(tmin)

  print *,'fortran milliseconds per iteration: ', double_matmul

end function double_matmul

Real(dp) function single_matmul(N,Nrun)

    integer, intent(in) :: N,Nrun

    real(sp),allocatable :: A(:,:),B(:,:),D(:,:)

    integer :: k
    integer(i64) :: tic,toc,tmin=huge(0)

    allocate(A(N,N))
    allocate(B(N,N))
    allocate(D(N,N))
    D=0.0 

    call init_random_seed()

! https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90

    print *,'priming single-prec. matmul loop'
    ! recommended to call once before loop per Intel manual
    call sgemm('N','N',N,N,N,1.0,A,N,B,N,1.0,D,N)

    do k = 1, Nrun
    !refilling arrays with random numbers to be sure a clever compiler doesn't workaround
        call random_number(A)
        call random_number(B)
        
        call system_clock(tic)
        call sgemm('N','N',N,N,N,1.0,A,N,B,N,1.0,D,N)  !single prec only
        !D = matmul(A,B) !4-5 times slower with ifort 14 than gfortran 5!
        call system_clock(toc)
        
        if (toc-tic<tmin) tmin=toc-tic
       
        if (mod(k,1).eq.0) write(*,'(F5.1,A10)') real(k)/Nrun*100.,'% done'
    end do

    single_matmul=sysclock2ms(tmin)

  print *,'fortran milliseconds per iteration: ', single_matmul

end function single_matmul

end module benchmark_matmul
