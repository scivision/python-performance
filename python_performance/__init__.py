from __future__ import annotations
import subprocess
import sys
import shutil
import os
from pathlib import Path
import typing as T

R = Path(__file__).parents[1] / "build"


def compiler_info() -> dict[str, str]:
    """
    assumes CMake project has been generated
    """
    fn = R / "CMakeCache.txt"

    if not fn.is_file():
        print("Must build Fortran / C code via CMake", file=sys.stderr)
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

    # %% versions
    cvers = fvers = ""
    try:
        if cc == "clang":
            cvers = subprocess.check_output([cc, "-dumpversion"], text=True).rstrip()
        elif cc == "gcc":
            ret = subprocess.check_output([cc, "--version"], text=True).split("\n")
            cvers = ret[0].split()[-1]
        elif cc in {"icc", "icx"}:
            ret = subprocess.check_output([cc, "--version"], text=True).split("\n")
            cvers = ret[0].split()[-2][:4]
        elif cc == "icl":
            ret = subprocess.check_output([cc, "--version"], text=True).split("\n")
            cvers = ret[0].split()[-1]
        elif cc == "nvcc":
            ret = subprocess.check_output([cc, "--version"], text=True).split("\n")
            cvers = ret[1].split()[1][:5]

        if fc == "flang":
            fvers = subprocess.check_output([fc, "-dumpversion"], text=True).rstrip()
        elif fc == "gfortran":
            ret = subprocess.check_output([fc, "--version"], text=True).split("\n")
            fvers = ret[0].split()[-1]
        elif fc in {"ifx", "ifort"}:
            ret = subprocess.check_output([fc, "--version"], text=True).split("\n")
            fvers = ret[0].split()[-2][:4]
        elif fc == "nvfortran":
            ret = subprocess.check_output([fc, "--version"], text=True).split("\n")
            fvers = ret[1].split()[1][:5]
    except (FileNotFoundError, subprocess.CalledProcessError):
        pass

    cinf = {"cc": cc, "ccvers": cvers, "fc": fc, "fcvers": fvers}

    return cinf


def run(cmd: list[T.Optional[str]], bdir: Path, lang: str = None) -> tuple[float, str]:
    if cmd[0] is None:
        raise EnvironmentError(f"{lang}: MISSING")

    if not lang:
        lang = cmd[0]

    path = None
    exe = None
    if cmd[0] == "octave-cli":
        oc = os.getenv("OCTAVE_EXECUTABLE")
        if oc is not None:
            path = Path(oc).parent
        if path:
            exe = shutil.which(cmd[0], path=str(path))
    if not exe:
        exe = shutil.which(cmd[0])
    if exe is None:
        raise EnvironmentError(f"{lang}: MISSING")

    if cmd[0] == "gdl":
        vers = subprocess.check_output(["gdl", "--version"], text=True).split()[-2]
        cmd += ["--fakerelease", vers]

    assert isinstance(exe, str)
    print("-->", lang)
    ret = subprocess.check_output([exe] + cmd[1:], cwd=bdir, text=True).split("\n")  # type: ignore
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
