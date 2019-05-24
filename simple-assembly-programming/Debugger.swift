extension CPU {
    func handleDebuggerInput(_ input:String) -> Bool {
        if input == "quit" {
            return true
        }
        return false
    }
}
