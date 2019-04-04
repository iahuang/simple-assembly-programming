 
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
    //var disasm = Disassembler()
    var quit = false
    
    func run(){
        print("Enter path")
        while(!quit){
            let com = readLine()
            if let out = com{
                let nice = readTextFile(out)
                if(nice.message == nil){
                    exeBinary(arrStrToInt(splitStringIntoLines(expression: nice.fileText!)))
                } else {
                    print(nice.message!)
                }
            }
        }
    }
    
    func exeBinary(_ arr: [Int]){
        let loadProg = Program(entry: 43, data: arr)
        inteli7.loadProgram(prg: loadProg)
        inteli7.runIteration()
    }
    
    func arrStrToInt(_ arr: [String])-> [Int]{
        var newArr = [Int](repeating: 0, count: arr.count)
        for n in 0..<arr.count{
            newArr[n] = Int(arr[n])!
        }
        return(newArr)
    }
    
 }

 
