 
 //
 //  OracleVirtualBox.swift
 //  simple-assembly-programming
 //
 //  Created by Ethan Zhang on 3/24/19.
 //  Copyright © 2019 Ian Huang. All rights reserved.
 //

 import Foundation

 class VM{
    var inteli7 = CPU(memSize: 1000, numRegisters: 10)
    //var disasm = Disassembler()
    var quit = false


    func run(){
        while(!quit){
            print("Enter path")
            let com = readLine()
            if let out = com{
                if out == "quit" {
                    break
                }
                let nice = readTextFile(out)
                if(nice.message == nil){
                    exeBinary(arrStrToInt(splitStringIntoLines(expression: nice.fileText!)))
                    print("Assembly program ended with no errors")
                } else {
                    print(nice.message!)
                }

            }
        }
    }

    func exeBinary(_ arr: [Int]){
        var data = arr
        let arrData = [arr[0], arr[1]]
        data.removeFirst(2)
        let loadProg = Program(entry: arrData[1], data: data)
        inteli7.loadProgram(prg: loadProg)
        print(inteli7.execProg())
    }

    func arrStrToInt(_ arr: [String])-> [Int]{
        var newArr = [Int](repeating: 0, count: arr.count)
        for n in 0..<arr.count{
            newArr[n] = Int(arr[n])!
        }
        return(newArr)
    }
    
    func assmebleSAP(_ chunks: [String]){
        var tokens = [[String]](repeating: [""], count: chunks.count)
        
        for string in 0..<chunks.count{
            var check = tokenize(chunks[string])
            if let hold = check.last{
                var str = hold
                if str.first! == "\""{
                    str.removeFirst()
                    str.removeLast()
                    check[check.count - 1] = str
                }
            }
            tokens[string] = check
        }
        
        
    }
    
    func tokenize(_ str: String)-> [String]{
        var ret = str.split{$0 == " "}.map{ String($0) }
        var pointer = 0
        let origSize = ret.count - 1
        for n in ret{
            var strArr = [String]()
            if(n.first == ";"){
                ret.removeSubrange(pointer..<ret.count)
            }
            if(n.first == "\"" || n.first == "\\"){
                if(pointer != origSize){
                    for rem in pointer..<ret.count{
                        strArr.append(ret[rem])
                    }
                    ret.removeSubrange(pointer..<ret.count)
                    var append = strArr.joined(separator: " ")
                    append.removeFirst()
                    append.removeLast()
                    ret.append(getRidOfThePoop(append))
                }
            }
            pointer += 1
        }
        return(ret)
    }
    
    func runAss(){
        while(!quit){
            print("Enter path")
            let com = readLine()
            if let out = com{
                if out == "quit" {
                    break
                }
                let nice = readTextFile(out)
                if(nice.message == nil){
                    assmebleSAP(splitStringIntoLines(expression: nice.fileText!))
                    print("Assembly program ended with no errors")
                } else {
                    print(nice.message!)
                }
                
            }
        }
    }
 }
