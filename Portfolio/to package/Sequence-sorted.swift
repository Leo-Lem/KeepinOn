//
//  Sequence.sorted.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation

public extension Sequence {
    
    /***/
    func sorted<Value: Comparable>(
        by keyPath: KeyPath<Element, Value>
    ) -> [Element] {
        self.sorted(by: keyPath, using: <)
    }
    
    /***/
    func sorted<Value>(
        by keyPath: KeyPath<Element, Value>,
        using areInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Element] {
        try self.sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
}
