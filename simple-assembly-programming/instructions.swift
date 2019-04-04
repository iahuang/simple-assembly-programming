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
        rpc = to.value - 1
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
    func jmpne(to: Ref){
        if rcp != 0{
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
        stackPush(rpc)
        jmp(to: to)
        
        for regNum in 1...9 {
            stackPush(reg[regNum])
        }
        
    }
    func ret() {
        let returnTo = srStack.popLast()!
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
    func outcr(char: Ref)-> String{
        return(String(unicodeValueToCharacter(char.value)))
    }
    func printi(int: Ref)-> String{
        return("\(Int(int.value))")
    }
    func outs(label: MemoryReference)-> String{
        let dataStart = label.addr
        let stringLength = Int(get(dataStart))
        let stringStart = dataStart+1
        
        var result = ""
        for addr in stringStart...stringStart+stringLength {
            result += String((unicodeValueToCharacter(get(addr))))
        }
        return(result)
    }
    // outcr outs
}
