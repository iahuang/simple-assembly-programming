//
//  Disassembler.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/25/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

class Disassembler {
    // "clr r x m b" is shorthand for
    // clrr (code 1)
    // clrx (code 2)
    // clrm (code 3)
    // clrb (code 4)
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
    
    var mnemonics = Dictionary<Int, String>()
    
    init() {
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
                instructionCode+=1
            }
        }
        print(mnemonics)
    }
}
