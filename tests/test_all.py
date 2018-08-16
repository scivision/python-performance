#!/usr/bin/env python
import subprocess
import pytest
from pythonperformance import Path

root = Path(__file__).parents[1]


def test_hypot():
    subprocess.check_call(['RunHypot'])


def test_matmul():
    subprocess.check_call(['RunMatmul'])


def test_pisum():
    subprocess.check_call(['RunPisum'])


if __name__ == '__main__':
    pytest.main(['-xrsv', __file__])
