//
//  instructions.swift
//  simple-assembly-programming
//
//  Created by Ian Huang on 3/26/19.
//  Copyright © 2019 Ian Huang. All rights reserved.
//

import Foundation

extension CPU {
    func clr(target: Ref) {
        target.value = 0
    }
    func mov(src: Ref, dest: Ref) {
        dest.value = src.value
    }
    func add(src: Ref, dest: Ref) {
        dest.value += src.value
    }
    func sub(src: Ref, dest: Ref) {
        dest.value -= src.value
    }
    func mul(src: Ref, dest: Ref) {
        dest.value *= src.value
    }
    func div(src: Ref, dest: Ref) {
        dest.value /= src.value
    }
}
