module benchmark_hypot
    use, intrinsic :: iso_fortran_env, only : REAL64,INT64
    use perf, only : sysclock2ms
    Implicit None
contains

function benchhypot()
    integer :: j,i
    integer(INT64) :: tic,toc,tmin=huge(0_INT64)
    
    integer,parameter :: N=26,Nrun=1000000
    real(REAL64),parameter :: A(N)=[5,10,16,28,48,82,137,237,401,681,1154,1957,3317, &
                                    5623,9531,16155,27384,46415,78674,133352,226030,&
                                    383118,649381,100694,1865663,3162277]

    real(REAL64) :: benchhypot(N)
    real(REAL64) :: B(N),Thypot,Trsq
    ! volatile tells compiler that value is unpredictable, don't unroll, etc.
    real(kind=REAL64), volatile :: C(N)

    B=A
! priming
        call system_clock(tic)
       Do j = 1, Nrun
            C = hypot(A(i),B(i)) 
       End Do
       call system_clock(toc)
!---------------
    Do i = 1, N
       call system_clock(tic)
       Do j = 1, Nrun
            C = hypot(A(i),B(i)) 
       End Do
       call system_clock(toc)
       if (toc-tic<tmin) tmin=toc-tic       

   Thypot = sysclock2ms(tmin)
!----------- 
       call system_clock(tic)
       Do j = 1, Nrun
              C = sqrt(A(i)**2 + B(i)**2)       
       End Do
       call system_clock(toc)
       if (toc-tic<tmin) tmin=toc-tic 
 
    Trsq = sysclock2ms(tmin)

    benchhypot(i) = Trsq/Thypot

    End Do !i
  
  !print *,'fortran millisec per iteration ', benchhypot
end Function benchhypot

end module benchmark_hypot

