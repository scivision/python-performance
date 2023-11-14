# Python Performance

![Actions Status](https://github.com/scivision/python-performance/workflows/ci/badge.svg)

All benchmarks are platform-independent (run on any computing device with appropriate hardware).
CuPy tests require an NVIDIA GPU with CUDA toolkit installed.

## Install

This command prepares Python prereqs:

```sh
pip install -r requirements.txt
```

Using the C and/or Fortran tests requires compilation using CMake.

```sh
cmake --workflow --preset default
```

## Usage

Iterative benchmarks, here using the pisum algorithm:

```sh
python Pisum.py
```

![Pi (Machin) benchmark Windows 10 Intel 19.1](./gfx/pisum_intel_9750.png)

![Pi (Machin) benchmark Windows 10](./gfx/pisum_windows_9750H.png)

![Pi (Machin) benchmark](./gfx/pisum_gcc_unplug-2019-01.png)

---

Matrix Multiplication benchmarks:

```sh
python Matmul.py
```

### Hypotenuse

Observe that `hypot()` is faster from 1 to a few hundred elements, then
sqrt(x^2+y^2) becomes slightly faster. However, `hypot()` does not
overflow for arguments near REALMAX. For example, in Python:

```python
from math import sqrt, hypot

a=1e154; hypot(a,a); sqrt(a**2+a**2);

1.414213562373095e+154
inf
```

Execute the Hypot speed test by:

```sh
python RunHypot.py
```

![Python 3.6 hypot() vs rsq()](.gfx/py36hypot.png)

![Python 2.7 hypot() vs rsq()](./gfx/py27hypot.png)

![Python 3.5 hypot() vs rsq()](./gfx/py35hypot.png)

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
