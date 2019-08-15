import subprocess
import sys
import shutil
from pathlib import Path
from typing import Tuple, Dict, List

R = Path(__file__).parents[1] / "build"


def compiler_info() -> Dict[str, str]:
    """
    assumes CMake project has been generated
    """
    fn = R / "CMakeCache.txt"

    if not fn.is_file():
        print("Must build Fortran / C code via CMake or Meson", file=sys.stderr)
        return {"cc": "", "fc": "", "ccvers": "", "fcvers": ""}

    cc = ""
    fc = ""
    for ln in fn.open("r"):
        if ln.startswith("CMAKE_C_COMPILER:"):
            cc = ln.split("/")[-1].rstrip().replace(".exe", "")
        elif ln.startswith("CMAKE_Fortran_COMPILER:"):
            fc = ln.split("/")[-1].rstrip().replace(".exe", "")

    if cc == "cc":
        cc = "gcc"

    if fc == "f95":
        fc = "gfortran"
    # %% versions
    cvers = fvers = ""
    try:
        if cc == "clang":
            cvers = subprocess.check_output(
                [cc, "-dumpversion"], universal_newlines=True
            ).rstrip()
        elif cc == "gcc":
            ret = subprocess.check_output(
                [cc, "--version"], universal_newlines=True
            ).split("\n")
            cvers = ret[0].split()[-1]
        elif cc == "icc":
            ret = subprocess.check_output(
                [cc, "--version"], universal_newlines=True
            ).split("\n")
            cvers = ret[0].split()[-2][:4]
        elif cc == "icl":
            ret = subprocess.check_output(
                [cc, "--version"], universal_newlines=True
            ).split("\n")
            cvers = ret[0].split()[-1]
        elif cc == "pgcc":
            ret = subprocess.check_output(
                [cc, "--version"], universal_newlines=True
            ).split("\n")
            cvers = ret[1].split()[1][:5]

        if fc == "flang":
            fvers = subprocess.check_output(
                [fc, "-dumpversion"], universal_newlines=True
            ).rstrip()
        elif fc == "gfortran":
            ret = subprocess.check_output(
                [fc, "--version"], universal_newlines=True
            ).split("\n")
            fvers = ret[0].split()[-1]
        elif fc == "ifort":
            ret = subprocess.check_output(
                [fc, "--version"], universal_newlines=True
            ).split("\n")
            fvers = ret[0].split()[-2][:4]
        elif fc == "pgfortran":
            ret = subprocess.check_output(
                [fc, "--version"], universal_newlines=True
            ).split("\n")
            fvers = ret[1].split()[1][:5]
    except (FileNotFoundError, subprocess.CalledProcessError):
        pass

    cinf = {"cc": cc, "ccvers": cvers, "fc": fc, "fcvers": fvers}

    return cinf


def run(cmd: List[str], bdir: Path, lang: str = None) -> Tuple[float, str]:
    if cmd[0] is None:
        print(f"{lang}: MISSING", file=sys.stderr)
        return None

    if not lang:
        lang = cmd[0]

    exe = shutil.which(cmd[0])
    if exe is None:
        print(f"{lang}: MISSING", file=sys.stderr)
        return None

    if cmd[0] == "gdl":
        vers = subprocess.check_output(
            ["gdl", "--version"], universal_newlines=True
        ).split()[-2]
        cmd += ["--fakerelease", vers]

    try:
        print("-->", lang)
        ret = subprocess.check_output(
            [exe] + cmd[1:], cwd=bdir, universal_newlines=True
        ).split("\n")
        # print(ret)
        t = float(ret[-2].split()[0])
        # %% version
        vers = ""
        if cmd[0] in (
            "julia",
            "cython",
            "matlab",
            "numba",
            "python",
            "octave",
            "octave-cli",
            "pypy",
            "pypy3",
        ):
            vers = ret[0].split()[2]
        elif cmd[0] == "idl":
            vers = ret[-3].split()[0]
        elif cmd[0] == "gdl":
            vers = ret[-3].split()[0]

        return t, vers
    except subprocess.CalledProcessError:
        print(lang, ": ERROR", file=sys.stderr)

    return None
