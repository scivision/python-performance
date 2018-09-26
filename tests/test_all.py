#!/usr/bin/env python
import subprocess
import pytest
from pathlib import Path

root = Path(__file__).parents[1]


def test_hypot():
    subprocess.check_call(['RunHypot'])


def test_matmul():
    subprocess.check_call(['Matmul', '-N', '10'])


def test_pisum():
    subprocess.check_call(['Pisum', '-N', '100'])


if __name__ == '__main__':
    pytest.main(['-xrsv', __file__])
