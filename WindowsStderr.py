#!/usr/bin/env python
"""
Some Windows configs don't print *any* stderr messages.
This function is to help test such configurations.
"""
import logging

print("this is a stdout message")
logging.warning("this is a warning message")
logging.critical("this is a critical message")
raise RuntimeError("This is a RuntimeError")
