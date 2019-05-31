
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

    var predef = ["path /Users/ianhuang/Desktop/saptest", "asm Doubles"]

    func run(){
        while(!quit){
            print("Enter path")
            let com = readLine() // :String? = "/Users/ianhuang/Desktop/Doubles.bin"
            if let out = com{
                if out == "quit" {
                    break
                }
                var pathsegs = out.split(separator: ".")
                var sympath = String(out)[0..<(out.count-pathsegs[pathsegs.count-1].count)]+"sym"
                var nice = readTextFile(sympath)
                if(nice.message == nil){
                    inteli7.loadSym(nice.fileText!)
                } else {
                    print(nice.message!)
                }
                nice = readTextFile(out)
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
        print(arr)
        let arrData = [arr[0], arr[1]]
        data.removeFirst(2)
        let loadProg = Program(entry: arrData[1], data: data)
        inteli7.loadProgram(prg: loadProg)
        inteli7.execProg()
    }

    func arrStrToInt(_ arr: [String])-> [Int]{
        var newArr = [Int](repeating: 0, count: arr.count)
        for n in 0..<arr.count{
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
        result += "crashandburn  - Summerizes ian and ethan's time spent on this project\n"
        return(result)
    }

    func assmCalled(_ prgm: String)-> String{
        return("")
    }

    func runCalled(_ prgm: String)-> String{
        return("")
    }
    
    func whyIsIanBad(_ ianbad: [String])-> [Int]{
        var result = [Int](repeating: -420, count: ianbad.count)
        for index in 0..<result.count{
            result[index] = Int(ianbad[index])!
        }
        return(result)
    }

    func runAss(){
        print("Welcome to SAP!\n")
        print(printHelp())
        while(quit != true){
            print("Enter option...")
            let com = readLine()//predef.count > 0 ? predef.removeFirst() : nil
            if let out = com {
                let outArr = splitStringIntoParts(expression: out)
                if outArr.count == 0{
                    continue
                }
                switch(outArr[0]){
                case "crashandburn":
                    crashAndBurn()
                    break
                case "quit":
                    quit = true
                    print("Shutting down SAP")
                    break
                case "printlst":
                    if path == ""{
                        print("Please set a path")
                        break
                    }
                    if outArr.count < 2 {
                        print("Please provide a filename")
                        break
                    }
                    let nice = readTextFile(path + outArr[1] + ".txt")
                    print("Printing List From File: \(path + outArr[1] + ".txt")")
                    if(nice.message == nil){
                        assmbler.assemble(nice.fileText!)
                        let lstPrintOut = assmbler.getLst()
                        print(lstPrintOut)
                        //assmbler.clearListPrint()
                        print("Printing List ended with no errors")
                    } else {
                        print(nice.message!)
                    }
                    break
                case "printbin":
                    if path == ""{
                        print("Please set a path")
                        break
                    }
                    if outArr.count < 2{
                        print("Please provide a filename")
                        break
                    }
                    let nice = readTextFile(path + outArr[1] + ".txt")
                    print("Printing List From File: \(path + outArr[1] + ".txt")")
                    if(nice.message == nil){
                        var binPrintOut = ""
                        let bin = assmbler.assemble(nice.fileText!)
                        for n in bin{
                            binPrintOut += "\(n)\n"
                        }
                        print(binPrintOut)
                        print("Printing Binary ended with no errors")
                    } else {
                        print(nice.message!)
                    }
                    break
                case "printsym":
                    if path == ""{
                        print("Please set a path")
                        break
                    }
                    if outArr.count < 2{
                        print("Please provide a filename")
                        break
                    }
                    let nice = readTextFile(path + outArr[1] + ".txt")
                    print("Printing List From File: \(path + outArr[1] + ".txt")")
                    if(nice.message == nil){
                        assmbler.assemble(nice.fileText!)
                        let symPrintOut = assmbler.getSymTable()
                        print(symPrintOut)
                        print("Printing Symbol Table ended with no errors")
                    } else {
                        print(nice.message!)
                    }
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
                        let binFile = path + "\(outArr[1]).bin"
                        let symFile = path + "\(outArr[1]).sym"
                        let lstFile = path + "\(outArr[1]).lst"
                        let binFileURL = URL(fileURLWithPath: binFile, isDirectory: false)
                        let symFileURL = URL(fileURLWithPath: symFile, isDirectory: false)
                        let lstFileURL = URL(fileURLWithPath: lstFile, isDirectory: false)
                        let bin = assmbler.assemble(nice.fileText!)
                        var binPrintOut = assmbler.getBin()
                        let symPrintOut = assmbler.getSymTable()
                        let lstPrintOut = assmbler.getLst()
                        binStr = binPrintOut
                        symTabStr = symPrintOut
                        do {
                            try binPrintOut.write(to: binFileURL, atomically: false, encoding: .utf8)
                            try symPrintOut.write(to: symFileURL, atomically: false, encoding: .utf8)
                            try lstPrintOut.write(to: lstFileURL, atomically: false, encoding: .utf8)
                        }
                        catch {print("\(error)")}
                        //assmbler.clearListPrint()
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
                        assmbler.assemble(nice.fileText!)
                        exeBinary(whyIsIanBad(splitStringIntoLines(expression: assmbler.getBin())))
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
                    path = outArr[1]+"/"
                    print("Path set to \(outArr[1])")
                    break
                default:
                    print("Command \(outArr[0]) not recognized")
                }
            } else {
                break
            }
        }
    }
 }
