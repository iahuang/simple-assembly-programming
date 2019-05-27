 
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
    var assmbler = Assmbler()
    var path = ""
    var symTabStr = ""
    var binStr = ""
    var lstStr = ""

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
            print(arr[n])
            newArr[n] = Int(arr[n])!
        }
        return(newArr)
    }
    
    func printHelp()->String{
        var result = ""
        result += "SAP Help: \n"
        result += "asm <program name> - assemble the specified program \n"
        result += "run <program name> - run the specified program \n"
        result += "path <path specification> - set the path for the SAP program directory \n"
        result += "include final / but not name of file. SAP file must have an extension of .txt \n"
        result += "printlst <program name> - print listing file for the specified program \n"
        result += "printbin <program name> - print binary file for the specified program \n"
        result += "printsym <program name> - print symbol table for the specified program \n"
        result += "quit  - terminate SAP program \n"
        result += "help  - print help table \n"
        return(result)
    }
    
    func assmCalled(_ prgm: String)-> String{
        return("")
    }
    
    func runCalled(_ prgm: String)-> String{
        return("")
    }
    
    func runAss(){
        print("Welcome to SAP!\n")
        print(printHelp())
        while(quit != true){
            print("Enter option...")
            let com = readLine()
            if let out = com{
                let outArr = splitStringIntoParts(expression: out)
                if outArr.count == 0{
                    break
                }
                switch(outArr[0]){
                case "quit":
                    quit = true
                    print("Shutting down SAP")
                    break
                case "help":
                    print(printHelp())
                    break
                case "asm":
                    if path == ""{
                        print("Please set a path")
                        break
                    }
                    if outArr.count < 2{
                        print("Please provide a filename")
                        break
                    }
                    let nice = readTextFile(path + outArr[1] + ".txt")
                    print("Assembling File: \(path + outArr[1] + ".txt")")
                    if(nice.message == nil){
                        print("Assembly Succ")
                        let binFile = path + "\(outArr[1])bin.txt"
                        let symFile = path + "\(outArr[1])sym.txt"
                        let binFileURL = URL(fileURLWithPath: binFile, isDirectory: false)
                        let symFileURL = URL(fileURLWithPath: symFile, isDirectory: false)
                        var binPrintOut = ""
                        let bin = assmbler.assemble(nice.fileText!)
                        let symPrintOut = assmbler.getSymTable()
                        for n in bin{
                            binPrintOut += "\(n)\n"
                        }
                        binStr = binPrintOut
                        symTabStr = symPrintOut
                        do {
                            try binPrintOut.write(to: binFileURL, atomically: false, encoding: .utf8)
                            try symPrintOut.write(to: symFileURL, atomically: false, encoding: .utf8)
                        }
                        catch {print("\(error)")}
                    print("Assembly program ended with no errors")
                } else {
                    print(nice.message!)
                }
                    break
                case "run":
                    if path == ""{
                        print("Please set a path")
                        break
                    }
                    if outArr.count < 2{
                        print("Please provide a filename")
                        break
                    }
                    let nice = readTextFile(path + outArr[1] + ".txt")
                    print("Running File: \(path + outArr[1] + ".txt")")
                    if(nice.message == nil){
                        print("Running Succ")
                        let bin = assmbler.assemble(nice.fileText!)
                        exeBinary(bin)
                        print("Running program ended with no errors")
                    } else {
                        print(nice.message!)
                    }
                    break
                case "path":
                    if outArr.count < 2{
                        print("Please provide a path")
                        break
                    }
                    path = outArr[1]
                    print("Path set to \(outArr[1])")
                    break
                default:
                    print("Command \(outArr[0]) not recognized")
                }
            }
        }
    }
 }
