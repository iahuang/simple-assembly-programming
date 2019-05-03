//
//  sapCPU.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/23/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

extension BinaryInteger {
    var intvalue: Int {
        return self as! Int
    }
}

class CPU { // Int specifies the memory type. (e.g. Int64, Double)
    typealias Ref = Reference
    
    var reg = [Int]()
    var rpc: Int = 0 // Program counter
    var rcp: Int = 0 // Compare register
    var rst: Int = 0 // Stack pointer
    var programSize = 0
    
    var mem = [Int]()

    let memSize: Int
    let numRegisters: Int
    
    var stack = [Int]()
    
    var debugDisassembler = Disassembler()
    
    init (memSize:Int, numRegisters:Int = 10) {
        self.memSize = memSize
        self.numRegisters = numRegisters

        reg = Array.init(repeating: 0, count: numRegisters)
        mem = Array.init(repeating: 0, count: memSize)

        rst = memSize-1
    }
    
    //Increments program counter by 1 and returns next value in memory
    func digest()-> Int{
        rpc+=1
        return get(rpc)
    }
    
    func safetyCheck(_ addr: Int) -> Bool {
        if (addr < 0 || addr >= memSize) {
            return false
        }
        return true
    }
    
    func get(_ addr: Int) -> Int {
        if !safetyCheck(addr) {
            print("Segmentation fault 11: ex dumped")
            abort()
        }
        // you'll never guess what this does
        return mem[addr]
    }

    func getInt(_ addr: Int) -> Int {
        return get(addr)
    }

    func set(_ addr: Int, _ to: Int) {
        if !safetyCheck(addr) || addr < programSize {
            print("Segmentation fault 11: ex dumped")
            abort()
        }
        
        mem[addr] = to
    }

    func stackPush(_ data: Int) {
        rst+=1
        stack.append(data)
    }

    func stackPop() -> Int {
        rst-=1
        return stack.popLast()!
    }

    func reset() {
        reg = Array.init(repeating: 0, count: numRegisters)
        mem = Array.init(repeating: 0, count: memSize)

        rpc = 0
        rcp = 0
        rst = memSize-1
    }

    func copyTo(start: Int, buffer: [Int], _length: Int? = nil) {
        // Copy [length] items from array (default: size of array) to memory starting from address [start]
        // Equivalent to C++ "memcpy"

        let length = _length==nil ? buffer.count : _length!

        var bufferIndex = 0
        for addr in start...start+length {
            set(addr, buffer[bufferIndex])
            bufferIndex+=1
        }
    }

    func loadProgram(prg: Program, _ offset:Int = 0) {
        rpc = prg.entry+offset-1
        let data = prg.getData()
        var addr = offset
        for word in data {
            set(addr, Int.init(exactly: word)!)
            addr+=1
        }
    }

    func rInteration() {
        let inst = getInt(rpc)
        switch inst {
        case 0:
            abort()
        default:
            print("Illegal instruction")
            abort()
        }
    }
    
    
    func execProg()-> String{
        var result = ""
        var opcode = digest()
        while(opcode != 0){
            //print("\(debugDisassembler.mnemonics[opcode]) \(rpc)")
            switch mem[rpc]{
            case 1: clr(target: RegisterReference(self, digest()))
            case 2: clr(target: MemoryReference(self, digest()))
            case 3: clr(target: MemoryReference(self, digest()))
            //case 4: clrb()
            case 5: mov(src: ConstantReference(self, digest()), dest: RegisterReference(self, digest()))
            case 6: mov(src: RegisterReference(self, digest()), dest: RegisterReference(self, digest()))
            case 7: mov(src: RegisterReference(self, digest()), dest: MemoryReference(self, digest()))
            case 8: mov(src: MemoryReference(self, digest()), dest: RegisterReference(self, digest()))
            case 9: mov(src: MemoryReference(self, digest()), dest: MemoryReference(self, digest()))
            case 10: mov(src: ConstantReference(self, digest()), dest: RegisterReference(self, digest()))
            case 11: movb(src: digest(), dest: digest(), count: digest())
            case 12: add(src: ConstantReference(self, digest()), dest: RegisterReference(self, digest()))
            case 13: add(src: RegisterReference(self, digest()), dest: RegisterReference(self, digest()))
            case 14: add(src: MemoryReference(self, digest()), dest: RegisterReference(self, digest()))
            case 15: add(src: IndirectReference(self, digest()), dest: RegisterReference(self, digest()))
            case 16: sub(src: ConstantReference(self, digest()), dest: RegisterReference(self, digest()))
            case 17: sub(src: RegisterReference(self, digest()), dest: RegisterReference(self, digest()))
            case 18: sub(src: MemoryReference(self, digest()), dest: RegisterReference(self, digest()))
            case 19: sub(src: IndirectReference(self, digest()), dest: RegisterReference(self, digest()))
            case 20: mul(src: ConstantReference(self, digest()), dest: RegisterReference(self, digest()))
            case 21: mul(src: RegisterReference(self, digest()), dest: RegisterReference(self, digest()))
            case 22: mul(src: MemoryReference(self, digest()), dest: RegisterReference(self, digest()))
            case 23: mul(src: IndirectReference(self, digest()), dest: RegisterReference(self, digest()))
            case 24: div(src: ConstantReference(self, digest()), dest: RegisterReference(self, digest()))
            case 25: div(src: RegisterReference(self, digest()), dest: RegisterReference(self, digest()))
            case 26: div(src: MemoryReference(self, digest()), dest: RegisterReference(self, digest()))
            case 27: div(src: IndirectReference(self, digest()), dest: RegisterReference(self, digest()))
            case 28: jmp(to: digest())
            case 29: sojz(target: RegisterReference(self, digest()), jump: digest())
            case 30: sojnz(target: RegisterReference(self, digest()), jump: digest())
            case 31: aojz(target: RegisterReference(self, digest()), jump: digest())
            case 32: aojnz(target: RegisterReference(self, digest()), jump: digest())
            case 33: cmp(a: ConstantReference(self, digest()), b: RegisterReference(self, digest()))
            case 34: cmp(a: RegisterReference(self, digest()), b: RegisterReference(self, digest()))
            case 35: cmp(a: MemoryReference(self, digest()), b: RegisterReference(self, digest()))
            case 36: jmpn(to: digest())
            case 37: jmpz(to: digest())
            case 38: jmpp(to: digest())
            case 39: jsr(to: digest())
            case 40: ret()
            case 41: push(n: RegisterReference(self, digest()))
            case 42: pop(into: RegisterReference(self, digest()))
            case 43: stackc(into: RegisterReference(self, digest()))
            case 44: result += outc(char: ConstantReference(self, digest())) //is this 123 or char(123)??
            case 45: result += outc(char: RegisterReference(self, digest()))
            case 46: result += outc(char: IndirectReference(self, digest()))
            //case 47: result += outcb()
            //case 48: readi()
            case 49: result += printi(int: RegisterReference(self, digest()))
            //case 50: readc()
            //case 51: readln()
            //case 52: brk()
            case 53: mov(src: RegisterReference(self, digest()), dest: IndirectReference(self, digest()))
            case 54: mov(src: IndirectReference(self, digest()), dest: IndirectReference(self, digest()))
            case 55: result += outs(label: MemoryReference(self, digest()))
            case 56: nop()
            case 57: jmpne(to: digest())
            default:
                print("Illegal Instruction \(opcode)")
                abort()
            }
            opcode = digest()
        }
        return(result)
    }
    
    func restorebs(filePath: Bool) {
        print("the bs hath been restored")
    }
}
