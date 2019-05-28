extension CPU {
    func pmemArgToAddr(_ arg:String) -> Int {
        if ((arg.filter{!Array("0123456789").contains($0)}).count == 0) {
            return Int(arg)!
        }
        return labelAddresses[arg]!
    }
    func handleDebuggerInput(_ input:String) -> Bool {
        var parts = input.split(separator: " ")
        var command = parts[0]
        var args = [String]()
        if parts.count > 1 {
            args = parts[1..<parts.count].map(String.init)
        }
        switch command {
        case "quit":
            return true
        case "preg":
            print("Registers:")
            for rnum in 0...9 {
                print("  r\(rnum):  \(reg[rnum])")
            }
        case "pmem":
            print("Memory Dump:")
            for addr in pmemArgToAddr(args[0])..<pmemArgToAddr(args[1]) {
                print("  \(addr):  \(get(addr))")
            }
        case "pst":
            print("Symbol Table:")
            for (lable, addr) in labelAddresses {
                print("  \(addr):  \(get(addr))")
            }
        default:
            print("Unknown command")
        }
        return false
    }
}
