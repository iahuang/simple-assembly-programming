//
//  Assembler.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 4/1/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

enum assmCase{
    case label, string, tuple, start, regular
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

var argTable = buildArgTable()

func buildMnemonicTable () -> [Int:String] {
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
            var argtypes = suffix.map { String($0) }
            
            if ["aoj", "soj", "mp"].contains(base) {
                argtypes = ["m"]
            } else if suffix == "b" {
                argtypes = ["r", "r", "r"]
            }
            
            argtable[base+String(suffix)] = argtypes
        }
    }
    return argtable
}

func groupQuotes(_ s: String, _ grouping:[String]) -> [String] {
    var stack = [String]()
    var block = ""
    var string = [String]()
    for c in s {
        var c = String(c)
        if grouping.contains(c) { // Open group
            if stack.count == 0 { // Lowest level
                stack.append(c)
                block = c
            } else if stack[stack.count-1] == c { // Close group
                string.append(block+c)
                stack.popLast()
                block = ""
            } else {
                stack.append(c)
            }
        } else if stack.count == 0 { // Is on root nesting, and delimiter is reached
            string.append(c)
        } else {
            block += c
        }
    }
    
    if block.count != 0 {
        string.append(block)
    }
    
    return string
}

func splitChunks(_ chunks: [String], _ delimiter: Character) -> [String] {
    var chunks = chunks // Set argument to writeable
    chunks.append(String(delimiter)) // Ensure last block gets added
    
    var newChunks = [String]()
    var block = ""
    
    for chunk in chunks {
        if chunk == String(delimiter) {
            newChunks.append(block)
            block = ""
        } else {
            block+=chunk
        }
    }
    return newChunks
}

func tokenizer(_ prgm: String) -> [[String]] {
    var lines = [[String]]()
    for line in prgm.split(separator: "\n") {
        var line = NSString(string: String(line)).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var chunks = splitChunks(groupQuotes(line, ["\"","\\"]), " ")
        
        lines.append(chunks.filter{$0.count != 0})
    }
    return lines
}

func assemble(prgm: String)-> [Int]{
    var symbolTable = [String : Int]()
    
    return([0])
}

func writeString(_ str: [String])-> [Int]{
    if(str[0] != ".string" || str.count != 2){
        print("Did not pass a valid String Arg")
        return([0])
    }
    var arrStr = Array(str[1])
    var result = [Int](repeating: -1, count: str[1].count)
    for n in 0..<arrStr.count{
        result[n] = characterToUnicode(arrStr[n])
    }
    return(result)
}

func writeTuple(_ str: [String])-> [Int]{
    return([0])
}

func writeRegInst(_ str: [String])-> [Int]{
    return([0])
}

func findAssmCase(_ line: [String])-> assmCase{
    if(line[0] == ".start"){return(assmCase.start)}
    if(line[0] == ".string"){return(assmCase.string)}
    if(line[0] == ".tuple"){return(assmCase.tuple)}
    if let check = line[0].last{
        if(check == ":"){return(assmCase.label)}
    }
    return(assmCase.regular)
}
