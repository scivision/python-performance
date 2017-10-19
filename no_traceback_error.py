#!/usr/bin/env python
"""
disables annoying long error traceback.
Suggest using in top-level script so it's easy to put back to default
if debugging needed.

0 doesn't work. 
None prints only error message, no traceback
1 shows error and line error occured in.
"""
import sys
sys.tracebacklimit=None  # 0 doesn't work, but None does.

def funA():
    funB()
    
def funB():
    funC()
    
def funC():
    funD()
    
def funD():
    raise RuntimeError('Demoing traceback disable')
    
funA()
