//
//  sapCPU.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/23/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

class CPU<Unit: BinaryInteger> { // Unit specifies the memory type. (e.g. Int64, Double)
    typealias Ref = Reference<Unit>
    var reg = [Unit]()
    var rpc: Int = 0 // Program counter
    var rcp: Unit = 0 // Compare register
    var rst: Int = 0 // Stack pointer
    var programSize = 0
    
    var mem = [Unit]()

    let memSize: Int
    let numRegisters: Int
    
    var safeMode = false
    
    init (memSize:Int, numRegisters:Int = 10) {
        self.memSize = memSize
        self.numRegisters = numRegisters

        reg = Array.init(repeating: 0, count: numRegisters)
        mem = Array.init(repeating: 0, count: memSize)

        rst = memSize-1
    }
    
    func safetyCheck(_ addr: Int) -> Bool {
        if (addr < 0 || addr >= memSize) {
            return false
        }
        return true
    }
    
    func get(_ addr: Int) -> Unit {
        if !safetyCheck(addr) {
            print("Segmentation fault 11: ex dumped")
            abort()
        }
        // you'll never guess what this does
        return mem[addr]
    }

    func getInt(_ addr: Int) -> Int {
        return get(addr) as! Int
    }

    func set(_ addr: Int, _ to: Unit) {
        if !safetyCheck(addr) || addr < programSize {
            print("Segmentation fault 11: ex dumped")
            abort()
        }
        
        mem[addr] = to
    }

    func stackPush(_ data: Unit) {
        rst+=1
        mem[rst] = data
    }

    func stackPop() -> Unit {
        let data = mem[rst]
        rst-=1
        return data
    }

    func reset() {
        reg = Array.init(repeating: 0, count: numRegisters)
        mem = Array.init(repeating: 0, count: memSize)

        rpc = 0
        rcp = 0
        rst = memSize-1
    }

    func copyTo(start: Int, buffer: [Unit], _length: Int? = nil) {
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
        rpc = prg.entry+offset
        let data = prg.getData()
        var addr = offset
        for word in data {
            set(addr, Unit.init(exactly: word)!)
            addr+=1
        }
    }

    func runIteration() {
        let inst = getInt(rpc)
        switch inst {
        case 0:
            abort()
        default:
            print("Illegal instruction")
            abort()
        }
    }

    func restorebs(filePath: Bool) {
        print("the bs hath been restored")
    }
}
