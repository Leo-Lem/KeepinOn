//	Created by Leopold Lemmermann on 10.10.22.

import Foundation

extension Sequence {
  /// Removes all duplicates from the sequence.
  /// - Returns: An array without duplicates.
  @inlinable func removingDuplicates<T: Equatable>(
    by accessor: (Element) -> T
  ) -> [Element] {
    reduce([]) { items, next in
      let duplicate = items.contains { accessor($0) == accessor(next) }
      
      return duplicate ? items : items + [next]
    }
  }

  /// Removes all duplicates from the sequence.
  /// - Returns: An array without duplicates.
  /// - Note: Works when the elements are equatable.
  @inlinable func removingDuplicates() -> [Element] where Element: Equatable {
    removingDuplicates { $0 }
  }
}
