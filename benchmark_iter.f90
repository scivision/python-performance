module benchmark_iter
    use, intrinsic :: iso_fortran_env, only : REAL64,INT64
    use perf, only : init_random_seed, sysclock2ms 
    Implicit None
contains
    
Real(kind=REAL64) function simple_iter(N,Nrun)
    Implicit None

    integer :: j,i
    integer(kind=INT64) :: tic,toc,tmin=huge(0)
    
    integer,Intent(in) :: N,Nrun
    real(kind=REAL64) :: A(N)
    ! volatile tells compiler that value is unpredictable, don't unroll, etc.
    real(kind=REAL64), volatile ::x

   call init_random_seed()
   
   
   Do j = 1, Nrun
       call random_number(A)
       call system_clock(tic)
       x = 0.d0
       Do i = 1, N
          x = 0.5*x + mod(A(i),10.)
       End Do   
       call system_clock(toc)
       if (toc-tic<tmin) tmin=toc-tic 
       
   End Do

    simple_iter = sysclock2ms(tmin)
   
  print *,'fortran millisec per iteration ', simple_iter
end Function simple_iter

end module benchmark_iter

