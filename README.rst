.. image:: https://travis-ci.org/scienceopen/python-performance.svg?branch=master
    :target: https://travis-ci.org/scienceopen/python-performance

==================
Python Performance
==================

All benchmarks are platform-indepenent (run on any computing device with appropriate hardware).
A few tests require an NVIDIA GPU with Cuda toolkit installed.

To compile the benchmarks::

    cd bin
    cmake ..
    make


Compiler selection
==================

Intel Fortran::

    FC=ifort cmake ..

GNU Fortran::

    FC=gfortran cmake ..


Benchmarks
===========
Iterative benchmarks::

    ./RunIter.py

Matrix Multiplication benchmarks::

    ./RunMatmul.py

Fortran
-------
"kind" demo::

    ./bin/kind

Hypotenuse
----------
Observe that hypot() is faster from 1 to a few hundred elements, then sqrt(x**2+y**2) becomes slightly faster, but hypot is more numerically stable::

    ./RunHypot.py


.. image:: py27hypot.png
  :alt: Python 2.7 hypot() vs rsq()
  :scale: 60%

.. image:: py35hypot.png
  :alt: Pyhton 3.5 hypot() vs rsq()
  :scale: 60%

Old Notes
=========
[ Numba 0.15.1 bug has been patched.](https://github.com/numba/numba/pull/857)

