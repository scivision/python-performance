#!/usr/bin/env python
install_requires = ['cython','matplotlib','numpy','xarray','netcdf4','numba']
tests_require = ['pytest','nose','coveralls']
# %%
from setuptools import setup,find_packages

setup(name='python-performance',
      packages=find_packages(),
      author='Michael Hirsch, Ph.D.',
      url='https://github.com/scivision/python-performance',
      long_description=open('README.rst').read(),
      description='Python, C, Fortran, Matlab, GNU Octave, IDL, GDL, Julia, CUDA benchmarks',
      install_requires=install_requires,
      tests_require=tests_require,
      extras_require={'tests':tests_require},
      python_requires='>=2.7',
      version = '0.2.0',
       classifiers=[
      'Development Status :: 4 - Beta',
      'Environment :: Console',
      'Intended Audience :: Developers',
      'Operating System :: OS Independent',
      'Programming Language :: Python',
      'Topic :: Software Development',
      ],
      include_package_data=True,
	  )

