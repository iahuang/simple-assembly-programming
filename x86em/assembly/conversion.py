import re
import os
from assembly.util import resource_path
from assembly.x86 import Parser, Token

REG32 = ["eax", "ebx", "ecx", "edx", "edi", "esi", "esp", "ebp"]
REG16 = ["ax", "bx", "cx", "dx"]
HI8 = ["ah", "bh", "ch", "dh"]
LO8 = ["al", "bl", "cl", "dl"]

class SAPLine:
    def __init__(self, type, name, *args):
        self.type = type
        self.name = name
        self.args = args

    def to_string(self):
        if self.type == "instruction":
            return "\t"+self.name+" "+" ".join(self.args)
        elif self.type == "directive":
            return "\t."+self.name+" "+" ".join(self.args)
        elif self.type == "label":
            return self.name+":"
        elif self.type == "comment":
            return "\t; "+self.name
        elif self.type == "raw":
            return "\t"+self.name


class SAPProgramSegment:
    def __init__(self):
        self.lines = []

    def write_inst(self, name, *args):
        self.lines.append(SAPLine("instruction", name, *args))

    def write_directive(self, name, *args):
        self.lines.append(SAPLine("directive", name, *args))

    def write_label(self, name):
        self.lines.append(SAPLine("label", name))

    def write_comment(self, seg):
        self.lines.append(SAPLine("comment", seg))

    def write_spacer(self):
        self.write_raw("")

    def write_raw(self, seg):
        self.lines.append(SAPLine("raw", seg))

    def write_seg(self, seg):
        self.lines += seg.lines
    
    def get_last(self):
        return self.lines[-1]
    
    def get_first(self):
        return self.lines[0]


class x86toSAP:
    def __init__(self, header):
        self.parser = Parser()

        self.header = header

        self.init = SAPProgramSegment()
        self.prg = SAPProgramSegment()

        self.init.write_label("x86_init")
        self.init.write_inst("nop")

    def convert_directive(self, directive):
        name = directive.name
        args = directive.args

        numeric_directives = ["zero", "value", "long"]
        str_directives = ["asciz", "ascii", "string"]

        if name in numeric_directives:
            if re.fullmatch("\\d+", args[0]):
                self.prg.write_directive("integer", "#"+args[0])
            else:
                last_label = self.prg.get_last()
                if last_label.type != "label":
                    print("Throwing")
                    exit()
                
                self.init.write_inst("movar", args[0], "r1")
                self.init.write_inst("movrm", "r1", last_label.name)
                self.prg.write_directive("integer", "#0")
        elif name in str_directives:
            self.prg.write_directive("string", args[0])

    def convert_label(self, label):
        self.prg.write_label(label.name)

    def to_register(self, token, reg):
        seg = SAPProgramSegment()
        reg = "r"+str(reg)

        if token.type == "register":
            seg.write_inst("movmr", token.value, reg)
        elif token.type == "constant":
            seg.write_inst("movir", "#"+token.value, reg)
        else:
            seg.write_comment("unknown token type "+token.type)
        return seg
    
    def to_ptr_register(self, token, reg):
        seg = SAPProgramSegment()
        reg = "r"+str(reg)
        
        if token.type == "register":
            seg.write_inst("movar", token.value, reg)
        elif token.type == "constant":
            print("A constant cannot be assigned to")
        elif token.type == "label":
            seg.write_inst("movar", token.value, reg)
        else:
            seg.write_comment("unknown token type "+token.type)

        return seg

    def convert_inst(self, inst):
        seg = SAPProgramSegment()
        mne = inst.inst # mne pohoi
        args = inst.args
        if mne == "push":
            seg.write_seg(self.to_register(args[0], reg=1))
            seg.write_raw("call x86push r1")
        elif mne == "pop":
            seg.write_seg(self.to_ptr_register(args[0], reg=1))
            seg.write_raw("call x86pop")
            seg.write_inst("movrx", "r0", "r1")
        elif mne == "mov":
            seg.write_seg(self.to_register(args[1], reg=1))
            seg.write_seg(self.to_ptr_register(args[0], reg=2))
            seg.write_inst("movrx", "r1", "r2")
        elif mne == "call":
            seg.write_raw("call x86push #0") # Pretend to push the program counter on the stack
            seg.write_inst("jsr", args[0].value)
        elif mne == "ret":
            seg.write_raw("call x86pop") # Pretend to pop the program counter off the stack
            seg.write_inst("ret")
        else:
            seg.write_comment("unknown command "+inst.inst)
        return seg
    def dump_program_segment(self, seg):
        output = ""
        for line in seg.lines:
            output += line.to_string()
            if line.type != "label":
                output += "\n"
        return output+"\n"

    def finalize(self):
        output = self.header+"\n"
        output += self.dump_program_segment(self.init)
        output += self.dump_program_segment(self.prg)

        return output

    def convert(self, string):
        self.parser.parse(string)
        for line in self.parser.lines:
            if line.type == "directive":
                self.convert_directive(line)
            elif line.type == "label":
                self.convert_label(line)
            elif line.type == "instruction":
                seg = self.convert_inst(line)
                self.prg.write_seg(seg)
                self.prg.write_spacer()

        return self.finalize()
