 
 //
 //  OracleVirtualBox.swift
 //  simple-assembly-programming
 //
 //  Created by Ethan Zhang on 3/24/19.
 //  Copyright © 2019 Ian Huang. All rights reserved.
 //
 
 import Foundation
 

 class VM{
    var inteli7 = CPU<Int64>(memSize: 420, numRegisters: 69)
    var disasm = Disassembler()
    var quit = false
    
    func run(){
        while(!quit){
            let com = readLine()
            print(com)
        }
    }
 }

 
