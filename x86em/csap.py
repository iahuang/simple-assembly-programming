import subprocess
import sys
from termcolor import colored
from assembly.conversion import x86toSAP
import os

argv = sys.argv[1:]


def c_compile(path, optimization=1):
    p = subprocess.run(["gcc",
                        "-S",
                        "-O"+str(optimization),
                        "-m32",
                        "-fno-asynchronous-unwind-tables",
                        "-masm=intel",
                        path])
    return p


def run():
    src_path = argv[0]
    optimization = 2
    for arg in argv:
        if arg.startswith("-O"):
            optimization = arg[2:]
    p = c_compile(src_path, optimization=optimization)
    if p.returncode != 0:
        print("GCC terminated with exit code "+str(p.returncode))
        exit(0)

    asm_path = os.path.splitext(src_path)[0]+'.s'
    converter = x86toSAP()
    with open(asm_path) as fl:
        print(converter.convert(fl.read()))


if __name__ == "__main__":
    run()
