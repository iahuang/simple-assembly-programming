//
//  Disassembler.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/25/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

extension CPU {
    func disassembleArgument(_ arg: Int, _ type: String) -> String {
        switch type {
        case "m":
            return addressLabels[arg]!
        case "r":
            return "r\(arg)"
        case "i":
            return "#\(arg)"
        default:
            return "Unknown"
        }
    }
    func disassemble(_ start: Int, _ end:Int) {
        var addr = start
        while addr < end {
            var line = ""

            if addressLabels.keys.contains(addr) {
                line += addressLabels[addr]!+": "
            } else {
                line += "    "
            }
            let mne = opcodeTable[get(addr)]!
            line+=mne
            let argTypes = argTable[mne]!
            
            for atype in argTypes {
                addr+=1
                line+=" "+disassembleArgument(get(addr), atype)
            }
            print(line)
            addr+=1
        }
    }
}

