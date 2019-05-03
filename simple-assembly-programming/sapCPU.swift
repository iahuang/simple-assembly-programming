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

    func digestReg() -> RegisterReference {
        return RegisterReference(self, digest())
    }

    func digestAddr() -> MemoryReference {
        return MemoryReference(self, digest())
    }

    func digestConst() -> ConstantReference {
        return ConstantReference(self, digest())
    }


    func execProg()-> String{
        var result = ""
        var opcode = digest()
        while(opcode != 0){
            //print("\(debugDisassembler.mnemonics[opcode]) \(rpc)")
            switch mem[rpc]{
            case 1: clr(target: digestReg())
            case 2: clr(target: digestAddr())
            case 3: clr(target: digestAddr())
            //case 4: clrb()
            case 5: mov(src: digestConst(), dest: digestReg())
            case 6: mov(src: digestReg(), dest: digestReg())
            case 7: mov(src: digestReg(), dest: digestAddr())
            case 8: mov(src: digestAddr(), dest: digestReg())
            case 9: mov(src: IndirectReference(self, digest()), dest: digestReg())
            case 10: mov(src: digestConst(), dest: digestReg())
            case 11:
                movb(src: digestReg(), dest: digestReg(), count: digestReg())
            case 12: add(src: digestConst(), dest: digestReg())
            case 13: add(src: digestReg(), dest: digestReg())
            case 14: add(src: digestAddr(), dest: digestReg())
            case 15: add(src: IndirectReference(self, digest()), dest: digestReg())
            case 16: sub(src: digestConst(), dest: digestReg())
            case 17: sub(src: digestReg(), dest: digestReg())
            case 18: sub(src: digestAddr(), dest: digestReg())
            case 19: sub(src: IndirectReference(self, digest()), dest: digestReg())
            case 20: mul(src: digestConst(), dest: digestReg())
            case 21: mul(src: digestReg(), dest: digestReg())
            case 22: mul(src: digestAddr(), dest: digestReg())
            case 23: mul(src: IndirectReference(self, digest()), dest: digestReg())
            case 24: div(src: digestConst(), dest: digestReg())
            case 25: div(src: digestReg(), dest: digestReg())
            case 26: div(src: digestAddr(), dest: digestReg())
            case 27: div(src: IndirectReference(self, digest()), dest: digestReg())
            case 28: jmp(to: digest())
            case 29: sojz(target: digestReg(), jump: digest())
            case 30: sojnz(target: digestReg(), jump: digest())
            case 31: aojz(target: digestReg(), jump: digest())
            case 32: aojnz(target: digestReg(), jump: digest())
            case 33: cmp(a: digestConst(), b: digestReg())
            case 34: cmp(a: digestReg(), b: digestReg())
            case 35: cmp(a: digestAddr(), b: digestReg())
            case 36: jmpn(to: digest())
            case 37: jmpz(to: digest())
            case 38: jmpp(to: digest())
            case 39: jsr(to: digest())
            case 40: ret()
            case 41: push(n: digestReg())
            case 42: pop(into: digestReg())
            case 43: stackc(into: digestReg())
            case 44: result += outc(char: digestConst()) //is this 123 or char(123)??
            case 45: result += outc(char: digestReg())
            case 46: result += outc(char: IndirectReference(self, digest()))
            //case 47: result += outcb()
            //case 48: readi()
            case 49: result += printi(int: digestReg())
            //case 50: readc()
            //case 51: readln()
            //case 52: brk()
            case 53: mov(src: digestReg(), dest: IndirectReference(self, digest()))
            case 54: mov(src: IndirectReference(self, digest()), dest: IndirectReference(self, digest()))
            case 55: result += outs(label: digestAddr())
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
