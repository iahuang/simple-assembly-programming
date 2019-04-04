//
//  main.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/22/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation


print(Bundle.main.resourcePath!)
if let filepath = Bundle.main.path(forResource: "util", ofType: "swift") {
    print("file exists")
} else {
    print("file does not exist")
}

//var vm = VM()
//vm.run()
