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

class Assmbler{
    var symbolTable = [String : Int]()
    var prgmLength = -420
    var listPrintOut = ""
    
    func getLength(_ token: [String], _ assmCase: assmCase)-> Int{
        if findAssmCase(token) == .regular{
            return(argTable[token[0]]!.count + 1)
        }
        if findAssmCase(token) == .string{
            return(token[1].count - 1)
        }
        if findAssmCase(token) == .tuple{
            return(5)
        }
        if(findAssmCase(token) == .start){
            return(0)
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
        let tokens = tokenizer(prgm)
        var index = 0
        
        for token in tokens{
            let info = tokenInfo(token)
            if(info.0 == .label){
                symbolTable[info.2!] = index
            }
            index += info.1
        }
        prgmLength = index
        var result = [Int](repeating: -69, count: index + 2)
        var counter = 0
        
        for token in tokens{
            let assmTok = assembleToken(token, type: findAssmCase(token))
            for n in assmTok{
                if counter > index + 1{
                    break
                }
                result[counter] = n
                counter += 1
            }
        }
        return(result)
    }
    
    func assembleToken(_ token: [String], type: assmCase)->[Int]{
        if type == .label{
            var result = token
            result.removeFirst()
            return(assembleToken(result, type: findAssmCase(result)))
        }
        if type == .regular{
            return(assembleReg(token))
        }
        if type == .string{
            return(writeString(token))
        }
        if type == .tuple{
            return(writeTuple(token))
        }
        if type == .start{
            return(writeStart(token))
        }
        if type == .int{
            return(writeInt(token))
        }
        if type == .allocate{
            return(writeAllocate(token))
        }
        return([-420])
    }
    
    func assembleReg(_ token: [String])-> [Int]{
        var result = [Int](repeating: -420, count: argTable[token[0]]!.count + 1)
        result[0] = mneTable[token[0]]!
        let args = argTable[token[0]]!
        var argTokens = token
        argTokens.removeFirst()
        for index in 0..<args.count{
            if args[index] == "m"{
                result[index + 1] = argMem(token: argTokens[index])
            }
            if args[index] == "r"{
                result[index + 1] = argReg(token: argTokens[index])
            }
            if args[index] == "i"{
                result[index + 1] = argInt(token: argTokens[index])
            }
            if args[index] == "x"{
                result[index + 1] = argIndirect(token: argTokens[index])
            }
            if args[index] == "a"{
                result[index + 1] = argAddress(token: argTokens[index])
            }
            if args[index] == "c"{
                result[index + 1] = argChar(token: argTokens[index])
            }
        }
        return(result)
    }
    
    func writeString(_ token: [String])-> [Int]{
        if(token[0] != ".string" || token.count != 2){
            print("Did not pass a valid String Arg")
            return([-420])
        }
        var str = token[1]
        str.removeFirst()
        str.removeLast()
        var arrStr = Array(str)
        var result = [Int](repeating: -1, count: str.count + 1)
        result[0] = str.count
        for n in 1..<result.count{
            result[n] = characterToUnicode(arrStr[n - 1])
        }
        return(result)
    }
    
    func writeTuple(_ token: [String])-> [Int]{
        var result = [Int](repeating: -420, count: 5)
        if(token[0] != ".tuple" || token.count != 2){
            print("Did not pass a valid Tuple Arg")
            return([-420])
        }
        var tuple = token[1]
        tuple.removeFirst()
        tuple.removeLast()
        let tupleArr = tuple.split{$0 == " "}.map{ String($0) }
        result[0] = Int(tupleArr[0])!
        result[1] = characterToUnicode(Character(tupleArr[1]))
        result[2] = Int(tupleArr[2])!
        result[3] = characterToUnicode(Character(tupleArr[3]))
        if tupleArr[4] == "r"{
            result[4] = 1
        } else {
            result[4] = -1
        }
        return(result)
    }
    
    func writeRegInst(_ token: [String])-> [Int]{
        return([0])
    }
    
    func writeAllocate(_ token: [String])-> [Int]{
        if(token[0] != ".allocate" || token.count != 2){
            print("Did not pass a valid Allocate Arg")
            return([-420])
        }
        var count = token[1]
        count.removeFirst()
        return([Int](repeating: 0, count: Int(count)!))
    }
    
    func writeInt(_ token: [String])-> [Int]{
        if(token[0] != ".integer" || token.count != 2){
            print("Did not pass a valid integer Arg")
            return([-420])
        }
        var result = token[1]
        result.removeFirst()
        return([Int(result)!])
    }
    
    func writeStart(_ token: [String])-> [Int]{
        return([prgmLength, symbolTable[token[1]]!])
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
    
    func checkDict(_ token: String)-> Int?{
        return(symbolTable[token])
    }
    
    func argInt(token: String)-> Int{
        var result = token
        result.removeFirst()
        return(Int(result)!)
    }
    
    func argMem(token: String)-> Int{
        if(checkDict(token) == nil){
            return(Int(token)!)
        }
        return(checkDict(token)!)
    }
    
    func argReg(token: String)-> Int{
        var result = token
        result.removeFirst()
        return(Int(result)!)
    }
    
    func argIndirect(token: String)-> Int{
        var result = token
        result.removeFirst()
        return(Int(result)!)
    }
    
    func argChar(token: String)-> Int{
        return(characterToUnicode(Character(token)))
    }
    
    func argAddress(token: String)-> Int{
        if(checkDict(token) == nil){
            return(Int(token)!)
        }
        return(checkDict(token)!)
    }
    
    func getSymTable()->String{
        var result = ""
        for (key, value) in symbolTable{
            result += "\(key): \(value)\n"
        }
        return(result)
    }
}
