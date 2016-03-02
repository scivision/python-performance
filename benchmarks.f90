program benchrandmult
! Fortran 2008
    use, intrinsic :: iso_fortran_env, only : REAL32,REAL64, INT64, &
            stdout=>output_unit, stderr=>error_unit

    !use benchmark_matmul,only: double_matmul,single_matmul
    !use benchmark_iter,only : simple_iter,mandeltest
    use benchmark_hypot,only: benchhypot
                                     
    Implicit None
    
    integer,parameter :: Nmatmul=5000, Nrunmatmul=10, Nmand=5
    integer,parameter :: Niter=1000000, Nruniter=100,Nrunmand=1000

    real(kind=REAL64) :: tdmatmul,tsmatmul,titer,tmandel,Rhypot(26)
!----- tests-----------
    !tdmatmul = double_matmul(Nmatmul,Nrunmatmul)
    !tsmatmul = single_matmul(Nmatmul,Nrunmatmul)

    !titer = simple_iter(Niter,Nruniter)
!------mandlebrot-------------
    !tmandel=mandeltest(Nmand,Nrunmand)
!------ hypot -----------------
     Rhypot = benchhypot()

    !write(stderr,*),tdmatmul,tsmatmul,titer,tmandel
    write(stderr,*) Rhypot

end program

