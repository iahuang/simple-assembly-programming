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
            let mne = base+String(suffix)
            var argtypes = suffix.map { String($0) }
            if mne == "movb" {
                argtypes = ["r", "r", "r"]
            } else if ["aoj", "soj", "jmp"].contains(base) {
                argtypes = ["m"]
            } else if suffix == "b" {
                argtypes = ["r", "r"]
            }
            
            argtable[base+String(suffix)] = argtypes
        }
    }
    return argtable
}

func getLength(_ token: [String], _ assmCase: assmCase)-> Int{
    if findAssmCase(token) == .regular{
        return(argTable[token[0]]!.count)
    }
    if findAssmCase(token) == .string{
        print(token)
        return(token[1].count)
    }
    if findAssmCase(token) == .tuple{
        return(5)
    }
    if(findAssmCase(token) == .start){
        return(1)
    }
    if(findAssmCase(token) == .int){
        return(1)
    }
    if(findAssmCase(token) == .allocate){
        var temp = token[1]
        temp.removeFirst()
        return(Int(temp)!)
    }
    return(-100)
}

func tokenInfo(_ token: [String])-> (assmCase, Int, String?){
    if findAssmCase(token) == .label{
        let newToken = arrayTake(m: 1, n: token.count - 1, arrayIn: token) as! [String]
        var temp = token[0]
        temp.removeLast()
        let labelName = temp
        return(findAssmCase(token), getLength(newToken, findAssmCase(newToken)), labelName)
    }
    if findAssmCase(token) == .regular{
        return(assmCase.regular, getLength(token, assmCase.regular), nil)
    }
    if findAssmCase(token) == .string{
        return(assmCase.string, getLength(token, assmCase.string), nil)
    }
    if findAssmCase(token) == .tuple{
        return(assmCase.tuple, getLength(token, assmCase.tuple), nil)
    }
    if(findAssmCase(token) == .start){
        return(assmCase.start, getLength(token, assmCase.start), nil)
    }
    if(findAssmCase(token) == .int){
        return(assmCase.int, getLength(token, assmCase.int), nil)
    }
    if(findAssmCase(token) == .allocate){
        return(assmCase.allocate, getLength(token, assmCase.allocate), nil)
    }
    return(assmCase.error, -69420, nil)
}

func assemble(_ prgm: String)-> [Int]{
    var symbolTable = [String : Int]()
    let tokens = tokenizer(prgm)
    var result = [Int](repeating: -69, count: 1000)
    var index = 0
    
    for token in tokens{
        let info = tokenInfo(token)
        if(info.0 == .label){
            symbolTable[info.2!] = index
        }
        index += info.1
    }
    print(symbolTable)
    return(result)
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
    if(line[0] == ".integer"){return(assmCase.int)}
    if(line[0] == ".allocate"){return(assmCase.allocate)}
    if let check = line[0].last{
        if(check == ":"){return(assmCase.label)}
    }
    return(assmCase.regular)
}
