//
//  Assembler.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 4/1/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

enum assmCase{
    case label, string, tuple, start, regular, int, allocate, error
}

var shorthandInstructionSet = [
    "halt",
    "clr r x m b",
    "mov ir rr rm mr xr ar b",
    "add ir rr mr xr",
    "sub ir rr mr xr",
    "mul ir rr mr xr",
    "div ir rr mr xr",
    "jmp",
    "soj z nz",
    "aoj z nz",
    "cmp ir rr mr",
    "jmp n z p",
    "jsr",
    "ret",
    "push",
    "pop",
    "stackc",
    "out ci cr cx cb",
    "readi",
    "printi",
    "read c ln",
    "brk",
    "mov rx xx",
    "outs",
    "nop",
    "jmpne"
]

let argTable = buildArgTable()
let mneTable = buildMnemonicTable()
var opcodeTable = buildOpcodeTable()

func buildMnemonicTable () -> [String:Int] {
    var mnemonics = [String:Int]()
    var names = [String]()
    var instructionCode = 0

    for inst in shorthandInstructionSet {
        var parts = inst.split(separator: " ")
        if parts.count == 1 {
            parts.append("") // Ensure that the base mnemonic gets added if there are no variations of it
        }
        let base = parts[0]

        for i in 1...parts.count-1 {
            let suffix = parts[i]
            mnemonics[base+String(suffix)] = instructionCode
            names.append(base+String(suffix))
            instructionCode+=1
        }
    }
    return mnemonics
}

func buildOpcodeTable () -> [Int:String] {
    var mnemonics = [Int:String]()
    var names = [String]()
    var instructionCode = 0

    for inst in shorthandInstructionSet {
        var parts = inst.split(separator: " ")
        if parts.count == 1 {
            parts.append("") // Ensure that the base mnemonic gets added if there are no variations of it
        }
        let base = parts[0]

        for i in 1...parts.count-1 {
            let suffix = parts[i]
            mnemonics[instructionCode] = base+String(suffix)
            names.append(base+String(suffix))
            instructionCode+=1
        }
    }
    return mnemonics
}

func buildArgTable() -> [String:[String]] {
    var argtable = [String:[String]]()
    for inst in shorthandInstructionSet {
        var parts = inst.split(separator: " ")
        if parts.count == 1 {
            parts.append("") // Ensure that the base mnemonic gets added if there are no variations of it
        }
        let base = parts[0]

        for i in 1...parts.count-1 {
            let suffix = parts[i]
            let mne = base+String(suffix)
            var argtypes = suffix.map { String($0) }
            if mne == "movb" {
                argtypes = ["r", "r", "r"]
            } else if ["aoj", "soj", "jmp", "jsr", "outs", "jmpne"].contains(base) {
                argtypes = ["m"]
            } else if ["push", "pop", "printi", "outcr"].contains(mne) {
                argtypes = ["r"]
            } else if suffix == "b" {
                argtypes = ["r", "r"]
            }

            argtable[base+String(suffix)] = argtypes
        }
    }
    return argtable
}

typealias LineLST = (text: String, bin: [Int], error: String?)

class Assmbler {
    var symbolTable = [String : Int]()
    var labelPlaceholders = [Int: String]()
    var prgmLength = -420
    var listPrintOut = ""
    var err = ""
    var lst = [LineLST]()
    var lineLst = LineLST("", [], nil)
    var pos = 0
    var entryLabel: String? = nil
    init (){

    }
    func parseInt (_ intLiteral: String) -> Int {
        if intLiteral.hasPrefix("#") {
            if let intValue = Int(String(intLiteral[1..<intLiteral.count])) {
                return intValue
            } else {
                lineLst.error = "Invalid integer literal"
                return 0
            }
        } else {
            lineLst.error = "Invalid integer literal"
            return 0

        }
    }
    
    func parseRawInt (_ intLiteral: String) -> Int {
        if let intValue = Int(intLiteral) {
            return intValue
        } else {
            lineLst.error = "Invalid integer literal"
            return 0
        }
    }


    func parseRegister(_ regLiteral: String) -> Int {
        if regLiteral.hasPrefix("r") {
            if let regValue = Int(String(regLiteral[1..<regLiteral.count])) {
                if regValue < 0 || regValue > 9 {
                    lineLst.error = "Register r\(regValue) does not exist"
                    return 0
                }
                return regValue
            } else {
                lineLst.error = "Invalid register"
                return 0
            }
        } else {
            lineLst.error = "Invalid register"
            return 0

        }
    }

    func writeToBin(_ v: Int) {
        lineLst.bin.append(v)
        pos+=1
    }

    func assembleDirective(_ tokens: [String]) {
        switch tokens[0] {
        case ".string":
            if !tokens[1].hasPrefix("\"") {
                lineLst.error = "Invalid string literal"
                writeToBin(0)
                break
            }
            if !tokens[1].hasSuffix("\"") {
                lineLst.error = "Invalid string literal"
                writeToBin(0)
                break
            }

            var ascii = String(tokens[1][1..<tokens[1].count-1]).ascii
            writeToBin(ascii.count)
            for n in ascii {
                writeToBin(Int(n))
            }
            break
        case ".integer":
            var intLiteral = tokens[1]
            lineLst.bin.append(parseInt(intLiteral))
            pos+=1
            break
        case ".allocate":
            var intLiteral = tokens[1]
            var al = parseInt(intLiteral)
            for i in 1...al {
                lineLst.bin.append(0)
            }
            pos+=al

            break
        case ".start":
            entryLabel = tokens[1]
            break
        case ".end":
            break
        case ".tuple":
            var tupleContent = String(tokens[1][1..<tokens[1].count-1]).trim() // Strip slashes from tuple string
            var tuple = tupleContent.split(separator: " ").map(String.init)
            if tuple.count != 5 {
                lineLst.error = "Incorrect number of tuple arguments"
                break
            }
            writeToBin(parseInt(tuple[0])) // State
            writeToBin(Int(tuple[1].ascii[0])) // Head
            writeToBin(parseInt(tuple[2])) // New State
            writeToBin(Int(tuple[3].ascii[0])) // New Head
            writeToBin(tuple[4].lowercased() == "r" ? 1 : -1) // Direction
            break
        default:
            lineLst.error = "Invalid directive \(tokens[0])"
            break

        }
    }

    func assembleInstruction(_ tokens:[String]) {
        var mne = tokens[0]
        if mneTable.keys.contains(mne) {
            writeToBin(mneTable[mne]!)
            var argTypes = argTable[mne]!
            var i = 1
            //print(mne,argTypes)
            for atype in argTypes {
                if i > tokens.count {
                    lineLst.error = "Too few arguments for instruction \(mne)"
                    writeToBin(0)
                }
                var arg = tokens[i]
                switch atype {
                case "r":
                    writeToBin(parseRegister(arg))
                    break
                case "i":
                    writeToBin(parseInt(arg))
                    break
                case "x":
                    writeToBin(parseRegister(arg))
                    break
                case "m":
                    labelPlaceholders[pos] = arg
                    writeToBin(0)
                    break
                case "a":
                    labelPlaceholders[pos] = arg
                    writeToBin(0)
                    break
                default:
                    break
                }
                i+=1
            }
        } else {
            lineLst.error = "Invalid instruction"
        }
    }

    func assembleLine(_ line: String) {
        var tokens = tokenize(line)
        var err:String? = nil
        lineLst = ("", [], nil)
        tokens = tokens.map{$0.trim()}

        if tokens.count == 0 {
            return
        }

        if tokens[0].hasSuffix(":") {
            symbolTable[(String(tokens[0][0..<tokens[0].count-1]))] = pos // Strip colon and add to symtable
            tokens = Array(tokens[1..<tokens.count]) // Remove label token
        }
        if tokens == [] {
            return
        }
        if tokens[0].hasPrefix(".") {
            assembleDirective(tokens)
        } else {
            assembleInstruction(tokens)
        }

        lineLst.text = line
        lst.append(lineLst)
    }
    func addressToLst(_ addr: Int) -> Int? {
        var p = 0
        var ln = 0
        for lineLst in lst {
            for b in lineLst.bin {
                if p == addr {
                    return ln
                }
                p+=1
            }
            ln+=1
        }
        return nil
    }
    func setInBinary(_ addr: Int, _ to: Int) {
        var p = 0
        var ln = 0
        for lineLst in lst {
            var i = 0
            for b in lineLst.bin {
                if p == addr {
                    lst[ln].bin[i] = to
                }
                i+=1
                p+=1
            }
            ln+=1
        }
    }
    func assemble(_ prgm: String) -> [Int] {
        var lines = splitStringIntoLines(expression: prgm)
        for line in lines {
            assembleLine(line)
        }

        for (addr, label) in labelPlaceholders {
            if symbolTable.keys.contains(label) {
                setInBinary(addr, symbolTable[label]!)
            } else {
                lst[addressToLst(addr)!].error = "Label \(label) was used but never defined"
            }
        }

        return []
    }

    func getSymTable() -> String {
        var out = ""
        for (label, addr) in symbolTable {
            out+="\(label) \(addr)\n"
        }
        return out
    }
    func compileBin() -> [Int] {
        var out = [Int]()
        var prgmSize = 0
        for lineLst in lst {
            for b in lineLst.bin {
                out.append(b)
                prgmSize+=1
            }
        }
        return [prgmSize, symbolTable[entryLabel!]!]+out
    }
    func getBin() -> String {
        var out = ""
        var prgmSize = 0
        for lineLst in lst {
            for b in lineLst.bin {
                out+=b.description+"\n"
                prgmSize+=1
            }
        }
        return "\(prgmSize)\n\(symbolTable[entryLabel!]!)\n"+out
    }
    func getLst() -> String {
        var out = ""
        var binColumn = [String]()
        var srcColumn = [String]()
        var errColumn = [String]()
        var pos = 0
        for lineLst in lst {
            var binText = "\(pos): "
            var binItemsPrinted = 0
            for b in lineLst.bin {
                if binItemsPrinted < 5 {
                    binText+=b.description+" "
                }
                pos+=1
                binItemsPrinted+=1
            }
            if let err = lineLst.error {
                errColumn.append("........\(err)")
            } else {
                errColumn.append("")
            }
            binColumn.append(binText)
            srcColumn.append(lineLst.text)

        }
        var bwidth = binColumn.map {$0.count}.max()!+2
        for i in 0..<binColumn.count {
            out+=binColumn[i]+String(repeating: " ", count: bwidth-binColumn[i].count)+srcColumn[i]+"\n"
            if errColumn[i] != "" {
                out+=errColumn[i]+"\n"
            }
        }
        return out+"\nSymbol Table:\n"+getSymTable()
    }
}
