#!/usr/bin/env python
install_requires = ['cython','numpy','pathlib2']
tests_require = ['pytest','nose','coveralls']
# %%
from setuptools import setup,find_packages
import subprocess, os

setup(name='python-performance',
      packages=find_packages(),
      author='Michael Hirsch, Ph.D.',
      url='https://github.com/scivision/python-performance',
      long_description=open('README.rst').read(),
      description='Python, C, Fortran, Matlab, GNU Octave, IDL, GDL, Julia, CUDA benchmarks',
      install_requires=install_requires,
      tests_require=tests_require,
      extras_require={'tests':tests_require,
                      'jit':['numba'], 
                      'io':['xarray','netcdf4','matplotlib'],},
      python_requires='>=2.7',
      version = '0.2.1',
       classifiers=[
      'Development Status :: 4 - Beta',
      'Environment :: Console',
      'Intended Audience :: Developers',
      'Operating System :: OS Independent',
      'Programming Language :: Python',
      'Topic :: Software Development',
      ],
      scripts=['RunHypot.py','RunMatmul.py','RunNoneVsNan.py','RunPisum.py'],
      include_package_data=True,
	  )


if not os.name == 'nt':
    subprocess.check_call(['cmake','..'],cwd='bin')
    subprocess.check_call(['make'],cwd='bin')
