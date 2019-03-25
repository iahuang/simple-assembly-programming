//
//  Program.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/25/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

class Program {
    var entry: Int
    var data: [Int]
    
    init (entry:Int, data: [Int]) {
        self.entry = entry
        self.data = data
    }
    
    func getData() -> [Int] {
        return data
    }
}
