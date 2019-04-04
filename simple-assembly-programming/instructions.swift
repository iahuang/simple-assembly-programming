//
//  instructions.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/26/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

extension CPU {
    func clr(target: Ref) {
        target.value = 0
    }
    func mov(src: Ref, dest: Ref) {
        dest.value = src.value
    }
    func add(src: Ref, dest: Ref) {
        dest.value += src.value
    }
    func sub(src: Ref, dest: Ref) {
        dest.value -= src.value
    }
    func mul(src: Ref, dest: Ref) {
        dest.value *= src.value
    }
    func div(src: Ref, dest: Ref) {
        dest.value /= src.value
    }
    func jmp(to: Ref) {
        rpc = to.value as! Int
    }
    func sojz(target: Ref, jump: Ref) {
        target.value -= 1
        if target.value == 0 {
            jmp(to: jump)
        }
    }
    func sojnz(target: Ref, jump: Ref) {
        target.value -= 1
        if target.value != 0 {
            jmp(to: jump)
        }
    }
    func aojz(target: Ref, jump: Ref) {
        target.value += 1
        if target.value == 0 {
            jmp(to: jump)
        }
    }
    func aojnz(target: Ref, jump: Ref) {
        target.value += 1
        if target.value != 0 {
            jmp(to: jump)
        }
    }
    func cmp(a: Ref, b: Ref) {
        rcp = b.value-a.value
    }
    func jmpn(to: Ref) {
        if rcp < 0 {
            jmp(to: to)
        }
    }
    func jmpz(to: Ref) {
        if rcp == 0 {
            jmp(to: to)
        }
    }
    func jmpp(to: Ref) {
        if rcp > 0 {
            jmp(to: to)
        }
    }
    func jsr(to: Ref) {
        stackPush(rpc as! Unit)
        jmp(to: to)
        
        for regNum in 1...9 {
            stackPush(reg[regNum])
        }
        
    }
    func ret() {
        let returnTo = srStack.popLast()! as! Unit
        jmp(to: ConstantReference(self, returnTo))
        for regNum in 9...1 {
            reg[regNum] = stackPop()
        }
    }
    func push(n: Ref) {
        stackPush(n.value)
    }
    func pop(into: Ref) {
        into.value = stackPop()
    }
    func outcr(char: Ref) {
        print((char.value as! Int).correspondingLetter()!)
    }
    func outs(label: MemoryReference<Unit>) {
        let dataStart = label.addr
        let stringLength = get(dataStart).intValue
        let stringStart = dataStart+1
        
        for addr in stringStart...stringStart+stringLength {
            print(get(addr).intValue.correspondingLetter()!, terminator:"")
        }
    }
    // outcr outs
}
