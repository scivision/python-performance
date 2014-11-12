# -*- coding: utf-8 -*-
import importlib
import platform as p
modules=('numpy','scipy','astropy','pandas','h5py','matplotlib','cython','numba','six','xlrd')
from os.path import join

def main(odir):
    with open(join(odir,'vers.log'),'w') as f:
        #first let's log system info
        f.write('\n'.join((p.node(),p.processor(),p.system(),p.platform())) + '\n' +
                   ' '.join((p.python_implementation(), p.python_version())) + '\n')
        #now we'll log module versions
        for mod in modules:
            try:
                m = importlib.import_module(mod)
                #print(mod,m.__version__)
                f.write(' '.join((mod, m.__version__)) + '\n')
            except ImportError:
                f.write(mod + ' not installed\n')

if __name__=='__main__':
    from sys import argv
    main(argv[1])
