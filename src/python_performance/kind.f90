program kindsize

use iso_c_binding, only: complex128=>c_double_complex, real64=>c_double, c_sizeof, real32=>c_float, complex64=>c_float_complex
implicit none (type,external)

complex(real32) :: s
complex(real64) :: d
complex(complex64) :: c
complex(complex128) :: z

print '(A12,I2,I4)', 'real32',real32,storage_size(s)
print '(A12,I2,I4)', 'real64',real64,storage_size(d)
print '(A12,I2,I4)', 'complex64',complex64,storage_size(c)
print '(A12,I2,I4)', 'complex128',complex128, storage_size(z)

end program
