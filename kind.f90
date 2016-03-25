program blah
use iso_c_binding,only:zp=>c_double_complex, dp=>c_double,sizeof=>c_sizeof,sp=>c_float,cp=>c_float_complex

complex(sp) :: s
complex(dp) :: d
complex(cp) :: c
complex(zp) :: z

write(*,*), sp,dp,cp,zp
write(*,*), sizeof(s),sizeof(d),sizeof(c),sizeof(z)

end program
