#!/usr/bin/env python
import subprocess
from pythonperformance import Path

root = Path(__file__).parents[1]

def test_scripts():
    for s in ('RunHypot.py','RunMatmul.py','RunPisum.py'):
        subprocess.check_call(['python',s])
