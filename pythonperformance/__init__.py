import subprocess as S
import warnings
import os
from pathlib import Path
from typing import Tuple, Optional, Dict, List


def compiler_info() -> Dict[str, str]:
    """
    assumes CMake project has been generated
    """
    fn = Path('bin') / 'CMakeCache.txt'
    cc = ''
    fc = ''
    for ln in fn.open('r'):
        if ln.startswith('CMAKE_C_COMPILER:'):
            cc = ln.split('/')[-1].rstrip()
        elif ln.startswith('CMAKE_Fortran_COMPILER:'):
            fc = ln.split('/')[-1].rstrip()

    if cc == 'cc':
        cc = 'gcc'

    if fc == 'f95':
        fc = 'gfortran'
# %% versions
    cvers = fvers = ''
    try:
        if cc == 'clang':
            cvers = S.check_output([cc, '-dumpversion'], universal_newlines=True).rstrip()
        elif cc == 'gcc':
            ret = S.check_output([cc, '--version'], universal_newlines=True).split('\n')
            cvers = ret[0].split()[-1]
        elif cc == 'icc':
            ret = S.check_output([cc, '--version'], universal_newlines=True).split('\n')
            cvers = ret[0].split()[-2][:4]
        elif cc == 'pgcc':
            ret = S.check_output([cc, '--version'], universal_newlines=True).split('\n')
            cvers = ret[1].split()[1][:5]

        if fc == 'flang':
            fvers = S.check_output([fc, '-dumpversion'], universal_newlines=True).rstrip()
        elif fc == 'gfortran':
            ret = S.check_output([cc, '--version'], universal_newlines=True).split('\n')
            fvers = ret[0].split()[-1]
        elif fc == 'ifort':
            ret = S.check_output([cc, '--version'], universal_newlines=True).split('\n')
            fvers = ret[0].split()[-2][:4]
        elif fc == 'pgf90':
            ret = S.check_output([cc, '--version'], universal_newlines=True).split('\n')
            fvers = ret[1].split()[1][:5]
    except (FileNotFoundError, S.CalledProcessError):
        pass

    cinf = {'cc': cc, 'ccvers': cvers,
            'fc': fc, 'fcvers': fvers}

    return cinf


def run(cmd: List[str], bdir: Path, lang: str = None) -> Optional[Tuple[float, str]]:
    if cmd[0].startswith('./'):
        if os.name == 'nt':
            cmd[0] = cmd[0][2:]

    if not lang:
        lang = cmd[0]

    try:
        print("-->", lang)
        ret = S.check_output(cmd, cwd=bdir, universal_newlines=True).split('\n')

        t = float(ret[-2].split()[0])
# %% version
        vers = ''
        if cmd[0] in ('julia', 'idl', 'cython', 'numba', 'python', 'octave', 'pypy', 'pypy3'):
            vers = ret[0].split()[2]
        elif cmd[0] == 'matlab':
            vers = ret[3].split()[0]
        elif cmd[0] == 'gdl':
            vers = ret[1].split()[0]

        return t, vers
    except FileNotFoundError:
        msg = 'missing {}'.format(cmd[0])
    except S.CalledProcessError:
        msg = 'failed to converge'

    warnings.warn(msg)

    return None
