import os
from subprocess import Popen, PIPE, STDOUT
from termcolor import colored
import subprocess

config = {
    "exec_path": "./Assembler_OSX",
    "project": "asm/turing",

}

def clean_path(path): # Stulin lazy
    if not path.endswith("/"):
        return path+"/"
    return path

project = config["project"]
project_dir = clean_path(os.path.dirname(project))
project_name = os.path.basename(project)

def safe_rm(p):
    if os.path.exists(p):
        os.remove(p)
        
def clean_dir():
    safe_rm(project+".lst")
    safe_rm(project+".bin")
    safe_rm(project+".sym")

def assemble():
    clean_dir()
    cmd = f'printf "path {project_dir}\\nasm {project_name}" | {config["exec_path"]}'
    p = subprocess.Popen([config['exec_path']], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, stdin=subprocess.PIPE, shell=True)
    p.communicate(input=bytes(f'path {project_dir}\nasm {project_name}', 'utf8'))
    # ps = subprocess.Popen(('printf', f'"path {project_dir}\nasm {project_name}"'), stdout=subprocess.PIPE)
    # output = subprocess.run(('./Assembler_OSX'), stdin=ps.stdout, stderr=subprocess.PIPE, stdout=subprocess.PIPE)

clean_dir()
assemble()
print("\nAssembling...\n")

if os.path.exists(project+".bin"):
    print(colored("Project compiled successfully","green"))
else:
    err_prefix = ".........."
    all_indices = lambda my_list,search: [i for i, x in enumerate(my_list) if x == search]
    with open(project+".txt") as fl:
        src_lines = fl.read().split("\n")
    with open(project+".lst") as fl:
        errs = 0
        prev = ""
        lst_lines = fl.read().split("\n")
        for ln, line in enumerate(lst_lines):
            if line.startswith(err_prefix):
                line_order = all_indices(lst_lines, prev).index(ln-1)
                src_ln = all_indices(src_lines, prev)[line_order]+1
                print(colored("line "+str(src_ln)+":","magenta"),prev)
                print(colored("\tError: "+line[len(err_prefix):],"red"))
                print()
                errs+=1
            prev = line
    print("")
    print(colored("Project compiled with "+str(errs)+" errors!","yellow"))
