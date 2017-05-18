program blah
use iso_c_binding,only:complex128=>c_double_complex, real64=>c_double, c_sizeof, real32=>c_float, complex64=>c_float_complex

complex(real32) :: s
complex(real64) :: d
complex(complex64) :: c
complex(complex128) :: z

print *, real32,real64,complex64,complex128
print *, c_sizeof(s),c_sizeof(d),c_sizeof(c),c_sizeof(z)

end program
