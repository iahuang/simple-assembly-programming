//
//  sapCPU.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/23/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

class CPU<Unit: Numeric> { // Unit specifies the memory type. (e.g. Int64, Double)
    var reg = [Unit]()
    var mem = [Unit]()
    
    init (memSize:Int, numRegisters:Int = 10) {
        reg = Array.init(repeating: 0, count: numRegisters)
        mem = Array.init(repeating: 0, count: memSize)
    }
    
    func get(_ addr: Int) -> Unit {
        return mem[addr]
    }
    
    func set(_ addr: Int, to: Unit) {
        mem[addr] = to
    }
    
    func copyTo(start: Int, buffer: [Unit], _length: Int? = nil) {
        let length = _length==nil ? buffer.count : _length!
        
        var bufferIndex = 0
        for addr in start...start+length {
            set(addr, to: buffer[bufferIndex])
            bufferIndex+=1
        }
    }
    
}
