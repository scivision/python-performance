.. image:: https://travis-ci.org/scienceopen/python-performance.svg?branch=master
    :target: https://travis-ci.org/scienceopen/python-performance

==================
Python Performance
==================

Benchmarks
===========

Matmul
------

Iterative
---------

Hypotenuse
----------

Observe that hypot() is faster from 1 to a few hundred elements, then sqrt(x**2+y**2) becomes slightly faster, but hypot is more numerically stable.

.. image:: py27hypot.png
  :alt: Python 2.7 hypot() vs rsq()
  :scale: 60%
  
.. image:: py35hypot.png
  :alt: Pyhton 3.5 hypot() vs rsq()
  :scale: 60%

Old Notes
=========
[ Numba 0.15.1 bug has been patched.](https://github.com/numba/numba/pull/857) 

