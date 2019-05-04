import re
import os
from assembly.util import resource_path
from assembly.x86 import Parser


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


class SAPProgramSegment:
    def __init__(self):
        self.lines = []

    def write_inst(self, name, *args):
        self.lines.append(SAPLine("instruction", name, *args))

    def write_directive(self, name, *args):
        self.lines.append(SAPLine("directive", name, *args))

    def write_label(self, name):
        self.lines.append(SAPLine("label", name))

    def write_inline(self, seg):
        self.lines += seg.lines
    
    def get_last(self):
        return self.lines[-1]


class x86toSAP:
    def __init__(self):
        self.parser = Parser()

        with open(resource_path("res/header.sap")) as fl:
            self.header = fl.read()

        self.init = SAPProgramSegment()
        self.prg = SAPProgramSegment()

        self.init.write_label("x86_init")

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

    def convert_inst(self, inst):
        mne = inst.inst
        args = inst.args
        self.prg.write_inst("movir", "r1", "r2")

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
                self.convert_inst(line)

        return self.finalize()
