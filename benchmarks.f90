program benchrandmult
! Fortran 2008
    use, intrinsic :: iso_fortran_env, only : REAL32,REAL64, INT64, &
            stdout=>output_unit, stderr=>error_unit

    use benchmark_matmul,only: double_matmul,single_matmul
    use benchmark_iter,only : simple_iter
                                     
    Implicit None
    
    integer,parameter :: Nmatmul=5000, Nrunmatmul=10
    integer,parameter :: Niter=1000000, Nruniter=100

    real(kind=REAL64) :: tdmatmul,tsmatmul,titer

    tdmatmul = double_matmul(Nmatmul,Nrunmatmul)
    tsmatmul = single_matmul(Nmatmul,Nrunmatmul)

    titer = simple_iter(Niter,Nruniter)

    write(stderr,*),tdmatmul,tsmatmul,titer

end program

