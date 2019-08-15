#!/usr/bin/env python
"""
Note that if terminal text line wraps, this method breaks. Be sure terminal is wide enough
or that you don't print more than 80 characters per line.
80 character is default Terminal & Command Prompt width.
"""
from time import sleep

# %% too wide
for i in range(20):
    x = f"testing {i-2}                                          "
    x += f" {i-1}           {i}                  {i+1}      {i+2} "
    print(x + "\r", end="")
    sleep(0.1)

print("done             ")
# %% progress indicator
N = 12

for i in range(N):
    sleep(0.5)
    print(f"{i/N*100:.1f} %\r", end="")
