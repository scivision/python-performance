# Python Performance

![Actions Status](https://github.com/scivision/python-performance/workflows/ci/badge.svg)

All benchmarks are platform-independent (run on any computing device with appropriate hardware).
CuPy tests require an NVIDIA GPU with CUDA toolkit installed.

## Install

This command prepares Python prereqs:

```sh
pip install -r requirements.txt
```

C and Fortran benchmarks requires building first using CMake.

```sh
cmake --workflow --preset default
```

## Usage

Iterative benchmarks, here using the pisum algorithm:

```sh
python Pisum.py
```

![Pi (Machin) benchmark](./gfx/pisum.png)

---

Matrix Multiplication benchmarks:

```sh
python Matmul.py
```

![Matrix Multiplication benchmark](./gfx/matmul.png)

### Hypotenuse

For **Python**,
[numpy.hypot()](https://numpy.org/doc/stable/reference/generated/numpy.hypot.html)
is faster up to about a hundred elements, then
[numpy.sqrt(x**2 + y**2)](https://numpy.org/doc/stable/reference/generated/numpy.sqrt.html)
becomes slightly faster.
The benefit of `hypot()` is to not overflow for arguments near REALMAX.

For example, in Python:

```python
from math import sqrt, hypot

a=1e154; hypot(a,a); sqrt(a**2+a**2);

1.414213562373095e+154
inf
```

For **Fortran**, observe that with Gfortran compiler that `sqrt(x**2 + y**2)` is slightly faster than `hypot(x,y)` in general across the tested array sizes.

Execute the Hypot speed test by:

```sh
python hypot/Hypot.py
```

![hypot() vs rsq()](./gfx/hypot.png)

## Notes

### Julia

Julia binaries are often downloaded to a particular directory.
Python doesn't pickup `.bash_aliases`, which is commonly used to point to Julia.

### MKL selection

https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor

We give a hint to CMake where your MKL libraries on.
For example:
```sh
MKLROOT=/opt/intel/mkl cmake ..
```
Of course this option can be combined with `FC`.

You can set this environment variable permanently for your convenience
(normally you always want to use MKL) by adding to your `~/.bashrc` the
line:
```sh
export MKLROOT=/opt/intel/mkl
```
