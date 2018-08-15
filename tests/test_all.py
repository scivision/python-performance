#!/usr/bin/env python
import subprocess
import pytest
from pythonperformance import Path

root = Path(__file__).parents[1]


def test_scripts():
    for s in ('RunHypot', 'RunMatmul', 'RunPisum'):
        subprocess.check_call([s])


if __name__ == '__main__':
    pytest.main(['-x', __file__])
