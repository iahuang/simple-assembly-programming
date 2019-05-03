import re
from assembly.util import rcut, lcut

PATTERNS = {
    "comment": "##(?!\").+$"
}


class x86Line:
    def __init__(self, type):
        self.type = type


class x86Token:
    def __init__(self, type, value):
        self.type = type
        self.value = value


class x86Inst(x86Line):
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

        return x86Token(t, value)

    def __init__(self, inst, args):
        self.inst = inst
        self.args = tuple([x86Inst.parse_token(arg) for arg in args])

        super().__init__("instruction")


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
        pass
    elif line.endswith(":"):
        pass

    else:
        inst = line.split(" ")[0]
        content = lcut(line, inst).strip()
        args = content.split(", ")

        return x86Inst(inst, args)

    pass


class x86Parser:
    def __init__(self):
        pass

    def parse(self, source):
        for line in source.split("\n"):
            line = parse_line(line)
