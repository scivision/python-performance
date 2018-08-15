#!/usr/bin/env python
from setuptools import setup
import subprocess
import os
setup()

if not os.name == 'nt':
    subprocess.check_call(['cmake', '..'], cwd='bin')
    subprocess.check_call(['cmake', '--build', '.'], cwd='bin')
