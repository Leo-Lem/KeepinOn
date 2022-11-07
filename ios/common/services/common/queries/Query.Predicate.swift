//	Created by Leopold Lemmermann on 17.10.22.

extension Query {
  struct Predicate {
    let property: String,
        comparison: Comparison,
        value: any CustomStringConvertible

    init(property: String, comparison: Comparison = .eq, value: any CustomStringConvertible) {
      self.property = property
      self.comparison = comparison
      self.value = value
    }

    init?(
      _ keyPath: PartialKeyPath<T>,
      _ comparison: Comparison = .eq,
      _ value: any CustomStringConvertible
    ) where T: Queryable {
      guard let property = T.keyPathDictionary[keyPath] else { return nil }
      self.init(property: property, comparison: comparison, value: value)
    }

    enum Comparison {
      case eq, neq, g, ge, l, le
    }
  }
}
