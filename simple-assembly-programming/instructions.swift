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
    func clrb(start: Ref, count: Ref) {
        //print("start: \(start.value) count: \(count.value)")
        for offset in 0...count.value-1 {
            clr(target: MemoryReference(self, start.value+offset))
        }
    }
    
    func mov(src: Ref, dest: Ref) {
        dest.value = src.value
    }

    func movb(src: Ref, dest: Ref, count: Ref) {
        // print("src: \(src.value) dest: \(dest.value) count: \(count.value)")
        for offset in 0...count.value-1 {
            set(dest.value+offset, get(src.value+offset))
        }
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

    func jmp(to: Int) {
        //print("jumping to \(to)")
        //usleep(200000)
        rpc = to - 1
    }

    func sojz(target: Ref, jump: Int) {
        target.value -= 1
        if target.value == 0 {
            jmp(to: jump)
        }
    }

    func sojnz(target: Ref, jump: Int) {
        target.value -= 1
        if target.value != 0 {
            jmp(to: jump)
        }
    }

    func aojz(target: Ref, jump: Int) {
        target.value += 1
        if target.value == 0 {
            jmp(to: jump)
        }
    }

    func aojnz(target: Ref, jump: Int) {
        target.value += 1
        if target.value != 0 {
            jmp(to: jump)
        }
    }

    func cmp(a: Ref, b: Ref) {
        rcp = b.value-a.value
    }

    func jmpn(to: Int) {
        if rcp < 0 {
            jmp(to: to)
        }
    }

    func jmpne(to: Int){
        if rcp != 0{
            jmp(to: to)
        }
    }

    func jmpz(to: Int) {
        if rcp == 0 {
            jmp(to: to)
        }
    }

    func jmpp(to: Int) {
        if rcp > 0 {
            jmp(to: to)
        }
    }

    func jsr(to: Int) {

        stackPush(rpc+1)
        jmp(to: to)

        for regNum in 5...9 {
            stackPush(reg[regNum])
        }

    }

    func ret() {
        for regNum in (5...9).reversed() {
            reg[regNum] = stackPop()
        }
        let returnTo = stackPop()
        jmp(to: returnTo)
    }

    func push(n: Ref) {
        stackPush(n.value)
    }

    func pop(into: Ref) {
        into.value = stackPop()
    }

    func outc(char: Ref)-> String{
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
        for addr in stringStart...stringStart+stringLength-1 {
            result += String((unicodeValueToCharacter(get(addr))))
        }
        return(result)
    }
    // outcr outs

    func stackc(into: RegisterReference){
        if(rst == 100){
            into.value = 1
            return
        }
        if(rst == 0){
            into.value = 2
            return
        }
        into.value = 0
    }

    func nop(){
        return
    }

    func brk() {
        while (true) {
            print("Sdb (\(rpc), \(get(rpc))> ", terminator: "")
            let _input = readLine()
            if let input = _input {
                let shouldReturn = handleDebuggerInput(input)
                if shouldReturn {
                    break
                }
            } else {
                // EOF
                break
            }
        }
    }

}
