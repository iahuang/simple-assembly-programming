'''
pySAP

A command-line wrapper for the SAP Assembler

'''

import os
from subprocess import Popen, PIPE, STDOUT
from termcolor import colored
import subprocess
import sys
import json
import glob
import getpass

sysargs = sys.argv[1:]

if "-h" in sysargs or "--help" in sysargs:
    print("""Use "python pySAP.py run" to also run the assembly program. Open config.json for options and more parameters. """)
    raise SystemExit

with open("config.json") as fl:
    config = json.load(fl)


def clean_path(path):  # Stulin lazy
    if not path.endswith("/"):
        return path+"/"
    return path


project = config["project"]
project_dir = clean_path(os.path.dirname(project))
project_name = os.path.basename(project)

vm_path = glob.glob("/Users/"+getpass.getuser()+"/Library/Developer/Xcode/DerivedData/" +
                    config["xcode-proj-name"]+"*")[0]+"/Build/Products/Debug/"+config["xcode-proj-name"]


def safe_rm(p):
    if os.path.exists(p):
        os.remove(p)


def clean_dir():
    safe_rm(project+".lst")
    safe_rm(project+".bin")
    safe_rm(project+".sym")


def assemble():
    clean_dir()
    p = subprocess.Popen(
        [config['exec_path']], stdout=subprocess.PIPE, stdin=subprocess.PIPE, shell=True)
    s = p.communicate(input=bytes(
        f'path {project_dir}\nasm {project_name}\nquit', 'utf8'))
    if p.returncode != 0:
        print(colored("Assembler returned non-zero error code " +
                      str(p.returncode), "red"))
        raise SystemExit


def run():
    p = subprocess.Popen([vm_path], stdin=subprocess.PIPE, shell=True)
    p.communicate(input=bytes(project+".bin\nquit", 'utf8'))


print(colored("\nLoading macros...\n", "blue"))
with open(config["macro_path"]) as fl:
    macros = json.load(fl)

print(colored("\nApplying macros...\n", "blue"))

with open(project+".txt") as fl:
    src_bak = fl.read()
    src_lines = src_bak.split("\n")

with open(project+".bak", "w") as fl:
    fl.write(src_bak)

for macro in macros:
    parts = macro.split(" ")
    query = "$"+parts[0]
    argnames = parts[1:]
    for i, line in enumerate(src_lines):
        if line.strip().startswith(";"):
            continue
        if query in line:
            line_insert_prefix = ""
            if line.startswith("    ") or line.startswith("\t"):
                line_insert_prefix = "\t"

            words = line.split(" ")
            args = words[words.index(
                query)+1:words.index(query)+len(argnames)+1]
            insertion = "\n".join(
                [line_insert_prefix+line for line in macros[macro]])
            insertion = insertion.strip()
            for argname, argvalue in zip(argnames, args):
                insertion = insertion.replace(argname, argvalue)
            src_lines[i] = line.replace(" ".join([query]+args), insertion)

print(colored("\nApplying pre-processing modifications...\n", "blue"))
for name in config["preprocessing"]:
    value = config["preprocessing"][name]
    if name == "emptyLabelToNOP" and value:
        for i, ln in enumerate(src_lines):
            if ln.split(";")[0].strip().endswith(":"):
                src_lines[i] = ln.split(";")[0].strip() + " nop"

if config["verbose"]:
    print(colored("Expanded macro output:\n", "blue"))
    print(colored("\n".join(
        [str(i)+":\t"+l for i, l in enumerate(("\n".join(src_lines)).split("\n"))]), "cyan"))

with open(project+".txt", "w") as fl:
    fl.write("\n".join(src_lines))
with open(project+".expanded.txt", "w") as fl:
    fl.write("\n".join(src_lines))

print(colored("\nAssembling...\n", "blue"))
with open(project+".txt") as fl:
    src_lines = fl.read().split("\n")

warnings = []
if not any([l.startswith(".start") for l in src_lines]):
    warnings.append(
        "Assembly contains no given entry point; defaulting to start of file")

for w in warnings:
    print(colored("Warning: "+w, "yellow"))
if warnings:
    print()

try:
    clean_dir()
    assemble()
finally:
    with open(project+".txt", "w") as fl:
        fl.write(src_bak)

if os.path.exists(project+".bin"):
    print(colored("Project compiled successfully", "green"))
    if "run" in sysargs:
        print(colored("\nRunning...\n", "blue"))
        run()
else:
    err_prefix = ".........."

    def all_indices(my_list, search): return [
        i for i, x in enumerate(my_list) if x == search]
    with open(project+".lst") as fl:
        errs = 0
        prev = ""
        lst_lines = fl.read().split("\n")
        for ln, line in enumerate(lst_lines):
            if line.startswith(err_prefix):
                line_order = all_indices(lst_lines, prev).index(ln-1)
                src_ln = all_indices(src_lines, prev)[line_order]+1
                print(colored("line "+str(src_ln)+":", "magenta"), prev)
                print(colored("\tError: "+line[len(err_prefix):], "red"))
                print()
                errs += 1
            prev = line

    print("")
    print(colored("Project compiled with "+str(errs)+" errors!", "yellow"))
