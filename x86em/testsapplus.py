
class Branch:
    def __init__(self):
        self.condition = None
        self.blocks = []
    def add_block(self, b):
        self.blocks.append(b)

def parse_if_chunks(_lines, prefix=""):
    chunks = []
    branch = Branch()
    bnblock = [None]
    nest = 0
    for line in _lines:
        if nest == 1:
            if line.strip().startswith("else"):
                branch.add_block(bnblock)
                bnblock = [None]
                if line.strip().startswith("else if "):
                    bnblock[0] = line
                
            elif line.strip().startswith("endif"):
                branch.add_block(bnblock)
                bnblock = [None]
            else:
                bnblock.append(line)
        if nest > 1:
            bnblock.append(line)

        if line.strip().startswith("if "):
            nest+=1
            if nest == 1:
                branch.condition = line
        if line.strip().startswith("endif"):
            nest-=1
            
            if nest == 0:
                chunks.append(branch)
                branch = Branch()
        elif nest == 0:
            chunks.append(line)
    return chunks

def expand_elif(chunks):
    for chunk in chunks:
        if isinstance(chunk, Branch):
            for block in chunk.blocks:
                if block[0] != None:
                    block.insert(1, block[0][len("else "):])
                    block.append("endif")
                del block[0]
    
test = """
if a == b
    yep
    hmmm
    if n > 3
        hmm
    endif
else if a > b
    oop
else
    nope
endif
yup
yp
sa
"""

chunks = parse_if_chunks(test.split("\n"))
print(chunks[1].blocks)
expand_elif(chunks)
print(chunks[1].blocks)
