//	Created by Leopold Lemmermann on 09.10.22.

import Foundation

extension Sequence {
  /// Allows sorting of the sequence by key paths.
  /// - Parameter keyPath: The key path leading to a comparable value by which to sort.
  /// - Returns: An array with the sorted elements of the sequence.
  @inlinable func sorted<Value: Comparable>(
    by keyPath: KeyPath<Element, Value>
  ) -> [Element] {
    self.sorted(by: keyPath, using: <)
  }

  /// Allows sorting of the sequence by key paths.
  /// - Parameters:
  ///   - keyPath: The key path leading to a value by which to sort.
  ///   - areInIncreasingOrder: A function describing how to order the values at the key path.
  /// - Returns: An array with the sorted elements of the sequence.
  @inlinable func sorted<Value>(
    by keyPath: KeyPath<Element, Value>,
    using areInIncreasingOrder: (Value, Value) throws -> Bool
  ) rethrows -> [Element] {
    try self.sorted {
      try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
    }
  }
}
