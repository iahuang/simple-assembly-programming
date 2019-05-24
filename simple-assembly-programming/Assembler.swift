//
//  Assembler.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 4/1/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

var doubles = """
.start test
begin: .integer #0
end: .integer #20
newline: .integer #10
intromess: .string "A program to print doubles"
doublemess: .string " doubled is "
; comments
test: movmr begin r8
    movmr end r9
    movmr newline r0
    outcr r0
do01: movrr r8 r1
    addrr r8 r1
    printi r8
    outs doublemess
    printi r1
    outcr r0
    cmprr r8 r9
    addir #1 r8
    jmpne do01
wh01: halt
""" 

func groupQuotes(quote: Character="\"") -> [String] {
    var chunks = [String]()
    for char in qu
}

func tokenize(prgm: String) -> [[String]] {

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

            if ["aoj", "soj", "jmp"].contains(base)
            if suffix == "b" {
                argtypes = ["r", "r", "r"]
            }

            argtable[base+String(suffix)] = argtypes
        }
    }
    return argtable
}

var mtable = buildMnemonicTable()

func assemble(prgm: String) {
    var symbolTable = [String : Int]()
    
}
