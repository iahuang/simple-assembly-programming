import re
from assembly.util import rcut, lcut

PATTERNS = {
    "comment": "##(?!\").+$"
}


class Line:
    def __init__(self, type):
        self.type = type


class Token:
    def __init__(self, type, value):
        self.type = type
        self.value = value


class Inst(Line):
    @staticmethod
    def parse_token(value):
        t = 'undefined'
        if re.search('\\b\w+\\b ptr', value):
            t = 'computed'
        elif re.search('^e\\w{2}', value):
            t = 'register'
        elif re.search('^[\\d+x]', value):
            t = 'constant'
        else:
            t = 'label'

        return Token(t, value)

    def __init__(self, inst, args):
        self.inst = inst
        self.args = tuple([Inst.parse_token(arg) for arg in args])

        super().__init__("instruction")


class Label(Line):
    def __init__(self, name):
        self.name = name
        super().__init__("label")


class Directive(Line):
    def __init__(self, name, args):
        self.name = name
        self.args = args
        super().__init__("directive")


def parse_line(line):
    line = line.strip()

    comment = re.findall(PATTERNS["comment"], line)
    if comment:
        line = rcut(line, comment[0])

    line = line.strip()

    line = line.replace("\t", " ")
    if line == "":
        return None

    if line.startswith("."):
        name = line.split(" ")[0]
        content = lcut(line, name).strip()
        args = content.split(", ")

        return Directive(name.strip("."), args)
    elif line.endswith(":"):
        return Label(line[:-1])

    else:
        inst = line.split(" ")[0]
        content = lcut(line, inst).strip()
        args = content.split(", ")

        return Inst(inst, args)

    return Line("undefined")


class Parser:
    def __init__(self):
        self.lines = []

    def parse(self, source):
        for linetext in source.split("\n"):
            line = parse_line(linetext)
            if line != None:
                self.lines.append(line)
