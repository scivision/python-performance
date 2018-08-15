#!/usr/bin/env python
import importlib
import platform as P
from argparse import ArgumentParser


def main():
    p = ArgumentParser(description='list python module versions')
    p.add_argument('-m', '--modules', help='list of modules whose versions you want to check',
                   default=['numpy', 'matplotlib'])
    p = p.parse_args()

    vers = detect_versions(p.modules)

    print(vers)


def detect_versions(modules):
    mlist = []
# %% first let's log system info
    versys = ' '.join((P.node(), P.processor(), P.system(), P.platform()))
    print(versys)

    mlist.append((P.python_implementation(), P.python_version()))
# %% now we'll log module versions
    for mod in modules:
        try:
            m = importlib.import_module(mod)
            mlist.append((mod, m.__version__))
        except ImportError:
            print(mod + ' not installed')

    return mlist


if __name__ == '__main__':
    main()
