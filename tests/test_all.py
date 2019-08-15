#!/usr/bin/env python
import subprocess
import pytest


def test_hypot():
    subprocess.check_call(["python", "RunHypot.py"])


def test_matmul():
    subprocess.check_call(["python", "Matmul.py", "-N", "10"])


def test_pisum():
    subprocess.check_call(["python", "Pisum.py", "-N", "100"])


if __name__ == "__main__":
    pytest.main([__file__])
