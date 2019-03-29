//
//  Commands.swift
//  simple-assembly-programming
//
//  Created by Ethan Zhang on 3/24/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

enum Commands: Int{
    case halt = 0, clrr, clrx, clrm, clrb, movir, movrr, movrm, movmr, movxr, movar, movb,addir, addrr, addmr, addxr, subir, subrr, submr, subxr, mulir, mulrr, mulmr, mulxr, divir, divrr, divmr, divxr, jmp, sojz, sojnz, aojz, aojnz, cmpir, cmprr, cmpmp, jmpn, jmpz, jmpp, jsr, ret, push, pop, stackc, outci, outcr, outcx, outcb, readi, printi, readc,  readln, brk, movrx, movxx, outs, nop, jmpne
}
