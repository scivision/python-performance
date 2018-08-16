#!/usr/bin/env python
from setuptools import setup
import subprocess
import os
setup()

if os.name == 'nt':
    subprocess.check_call(['cmake', '-G', 'MinGW Makefiles', '-DCMAKE_SH="CMAKE_SH-NOTFOUND"', '..'], cwd='bin')
else:
    subprocess.check_call(['cmake', '..'], cwd='bin')

subprocess.check_call(['cmake', '--build', '.'], cwd='bin')
