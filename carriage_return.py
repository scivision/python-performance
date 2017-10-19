#!/usr/bin/env python
from time import sleep

for i in range(20):
    x=f'testing {i-2}'
    x+=f' {i-1} {i}'
    print(x+'\r',end="")
    sleep(0.1)

print('done             ')