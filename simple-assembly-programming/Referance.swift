//
//  Referance.swift
//  simple-assembly-programming
//
//  Created by Ethan Zhang on 3/28/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

class Reference<Unit : Numeric> {
    var cpu: CPU<Unit>
    init (_ cpu: CPU<Unit>) {
        self.cpu = cpu
    }
    var value: Unit {
        get {
            return 0
        }
        set (to) {
            
        }
    }
}

class RegisterReference<Unit : Numeric> : Reference<Unit>  {
    var registerNum = 0
    
    init (_ cpu: CPU<Unit>, _ registerNum: Int) {
        self.registerNum = registerNum
        super.init(cpu)
    }
    
    override var value: Unit {
        get {
            return cpu.reg[registerNum]
        }
        set (to) {
            cpu.reg[registerNum] = to
        }
    }
}

class MemoryReference<Unit : Numeric> : Reference<Unit>  {
    var addr = 0
    
    init (_ cpu: CPU<Unit>, _ addr: Int) {
        self.addr = addr
        super.init(cpu)
    }
    
    override var value: Unit {
        get {
            return cpu.get(addr)
        } set (to) {
            cpu.set(addr, to)
        }
    }
}
