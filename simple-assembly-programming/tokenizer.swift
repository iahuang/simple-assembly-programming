//
//  tokenizer.swift
//  simple-assembly-programming
//
//  Created by Ethan Zhang on 5/23/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

func groupQuotes(_ s: String, _ grouping:[String]) -> [String] {
    var stack = [String]()
    var block = ""
    var string = [String]()
    for c in s {
        var c = String(c)
        if grouping.contains(c) { // Open group
            if stack.count == 0 { // Lowest level
                stack.append(c)
                block = c
            } else if stack[stack.count-1] == c { // Close group
                string.append(block+c)
                stack.popLast()
                block = ""
            } else {
                stack.append(c)
            }
        } else if stack.count == 0 { // Is on root nesting, and delimiter is reached
            string.append(c)
        } else {
            block += c
        }
    }
    
    if block.count != 0 {
        string.append(block)
    }
    
    return string
}

func splitChunks(_ chunks: [String], _ delimiter: Character) -> [String] {
    var chunks = chunks // Set argument to writeable
    chunks.append(String(delimiter)) // Ensure last block gets added
    
    var newChunks = [String]()
    var block = ""
    
    for chunk in chunks {
        if chunk == String(delimiter) {
            newChunks.append(block)
            block = ""
        } else {
            block+=chunk
        }
    }
    return newChunks
}

func tokenizer(_ prgm: String) -> [[String]] {
    var lines = [[String]]()
    for line in prgm.split(separator: "\n") {
        var line = NSString(string: String(line)).trimmingCharacters(in: .whitespacesAndNewlines)
        var chunks = splitChunks(groupQuotes(line, ["\"","\\"]), " ")
        
        lines.append(chunks.filter{$0.count != 0})
    }
    return lines
}
