//
//  util.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/22/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

// Put all helper functions here that you -s̶t̶o̶l̶e̶ ̶f̶r̶o̶m̶ ̶s̶t̶a̶c̶k̶ ̶o̶v̶e̶r̶f̶l̶o̶w̶- got from stulin

import Foundation


extension Character {
    var isAscii: Bool {
        return unicodeScalars.allSatisfy { $0.isASCII }
    }
    var ascii: UInt32? {
        return isAscii ? unicodeScalars.first?.value : nil
    }
}

extension StringProtocol {
    var ascii: [UInt32] {
        return compactMap { $0.ascii }
    }
}
