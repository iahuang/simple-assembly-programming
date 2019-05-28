import Foundation

let helpmsg = """
 - [memory] represents a memory address or label such as 42 or do01

help - Print this message
setbk [memory] - Create breakpoint at the specified location
clrbk - Clear all breakpoints
disbk - Disable breakpoints
enbk - Enable breakpoints
preg - Display registers
wreg [reg] [value] - Change r[reg] to [value]
wpc [value] - Change the value of the program counter
pmem [memory] [memory] - Display memory values from a up until b
wmem [memory] [value] - Write a value to memory
pst - Display symbol table
g - Continue running
s - Run the next instruction and return to the debugger
deas [memory] [memory] - Disassemble memory range a up until b
exit - Stop the program
"""
extension CPU {
    func pmemArgToAddr(_ arg:String) -> Int? {
        if ((arg.filter{!Array("0123456789").contains($0)}).count == 0) {
            return Int(arg)
        }
        return labelAddresses[arg]
    }
    func handleDebuggerInput(_ input:String) -> Bool {
        var parts = input.split(separator: " ")
        var command = parts[0]
        var args = [String]()
        if parts.count > 1 {
            args = parts[1..<parts.count].map(String.init)
        }
        switch command {
        case "exit":
            exit(0)
        case "preg":
            print("Registers:")
            for rnum in 0...9 {
                print("  r\(rnum):  \(reg[rnum])")
            }
            print("PC: \(rpc)")
        case "wreg":
            guard Int(args[0]) != nil else {
                print("\(args[0]) is not a valid number")
                return false
            }
            guard Int(args[1]) != nil else {
                print("\(args[1]) is not a valid number")
                return false
            }
            reg[Int(args[0])!] = Int(args[1])!
        case "pmem":
            print("Memory Dump:")
            let start = pmemArgToAddr(args[0])
            let end = pmemArgToAddr(args[1])
            guard start != nil && end != nil else {
                print("Invalid memory location")
                return false
            }
            for addr in start!..<end! {
                print("  \(addr):  \(get(addr))")
            }
        case "wmem":
            guard Int(args[1]) != nil else {
                print("\(args[1]) is not a valid number")
                return false
            }
            if let addr = pmemArgToAddr(args[0]) {
                set(addr, Int(args[1])!)
            } else {
                print("Invalid memory location")
            }
            
            
        case "pst":
            print("Symbol Table:")
            for (label, addr) in labelAddresses {
                print("  \(label):  \(addr)")
            }
        case "wpc":
            guard Int(args[0]) != nil else {
                print("\(args[0]) is not a valid number")
                return false
            }
            rpc = Int(args[0])!
        case "s":
            stepMode = true
            return true
        case "g":
            return true
        case "setbk":
            if let a = pmemArgToAddr(args[0]) {
                breakpoints.insert(a)
            } else {
                print("Invalid memory location")
            }
        case "rmbk":
            if let a = pmemArgToAddr(args[0]) {
                breakpoints.insert(a)
            } else {
                print("Invalid memory location")
            }
        case "clrbk":
            breakpoints = Set<Int>()
        case "enbk":
            bpEnabled = true
        case "disbk":
            bpEnabled = false
        case "pbk":
            print("Breakpoints:")
            for addr in breakpoints {
                print("  \(addr)")
            }
        case "help":
            print(helpmsg)
        case "deas":
            print("Dissassembly:")
            let start = pmemArgToAddr(args[0])
            let end = pmemArgToAddr(args[1])
            guard start != nil && end != nil else {
                print("Invalid memory location")
                return false
            }
            disassemble(start!, end!)
        default:
            print("Unknown command")
        }
        return false
    }
}
