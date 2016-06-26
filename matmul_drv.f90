Program run_matmul

    use, intrinsic :: iso_fortran_env, only : dp=>REAL64
    use benchmark_matmul,only: double_matmul,single_matmul

    Implicit None

    integer,parameter :: Nmatmul=5000, Nrunmatmul=10
    real(dp) :: tdmatmul,tsmatmul

    tdmatmul = double_matmul(Nmatmul,Nrunmatmul)
    tsmatmul = single_matmul(Nmatmul,Nrunmatmul)

     print *, 'double matmul (sec): ',tdmatmul
     print *, 'single matmul (sec): ',tsmatmul

End Program