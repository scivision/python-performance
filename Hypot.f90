Program run_hypot

    use, intrinsic :: iso_fortran_env, only : dp=>REAL64
    use benchmark_hypot,only: benchhypot

    Implicit None

     real(dp) :: Rhypot

     Rhypot = benchhypot()

     print *, 'sqrt(a^2+b^2) / hypot(a,b)  time ratio: ',Rhypot

End Program