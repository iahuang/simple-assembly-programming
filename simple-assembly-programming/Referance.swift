//
//  Referance.swift
//  simple-assembly-programming
//
//  Created by Ethan Zhang on 3/28/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

class Reference{
    var cpu: CPU
    init (_ cpu: CPU) {
        self.cpu = cpu
    }
    var value: Int {
        get {
            return 0
        }
        set (to) {
            
        }
    }
}

class RegisterReference: Reference {
    var registerNum = 0
    
    init (_ cpu: CPU, _ registerNum: Int) {
        self.registerNum = registerNum
        super.init(cpu)
    }
    
    override var value: Int {
        get {
            return cpu.reg[registerNum]
        }
        set (to) {
            cpu.reg[registerNum] = to
        }
    }
}

class MemoryReference: Reference {
    var addr = 0
    
    init (_ cpu: CPU, _ addr: Int) {
        self.addr = addr
        super.init(cpu)
    }
    
    override var value: Int {
        get {
            return cpu.get(addr)
        } set (to) {
            cpu.set(addr, to)
        }
    }
}

class ConstantReference: Reference {
    var _value: Int
    
    init (_ cpu: CPU, _ value: Int) {
        self._value = value
        super.init(cpu)
    }
    
    override var value: Int {
        get {
            return _value
        } set (to) {
            print("Error: Cannot set value of constant")
            abort()
        }
    }
}

class IndirectReference<Unit : BinaryInteger> : Reference<Unit>  {
    var registerNum = 0
    
    init (_ cpu: CPU<Unit>, _ registerNum: Int) {
        self.registerNum = registerNum
        super.init(cpu)
    }
    
    override var value: Unit {
        get {
            return cpu.get(cpu.reg[registerNum].intvalue)
        }
        set (to) {
            return cpu.set(cpu.reg[registerNum].intvalue, to)
        }
    }
}
