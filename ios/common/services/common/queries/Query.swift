//	Created by Leopold Lemmermann on 17.10.22.

import Foundation

struct Query<T> {
  let options: Options
  let bool: Bool?
  let predicates: [Predicate]?
  let compound: Compound?

  private init(
    bool: Bool? = nil,
    predicates: [Predicate]? = nil,
    compound: Compound? = nil,
    options: Options = Options()
  ) {
    self.bool = bool
    self.predicates = predicates
    self.compound = compound
    self.options = options
  }
}

extension Query {
  enum Compound {
    case and, or
  }
}

extension Query {
  init(
    _ bool: Bool,
    options: Options = Options()
  ) {
    self.init(
      bool: bool,
      options: options
    )
  }

  init(
    _ predicates: [Predicate],
    compound: Compound,
    options: Options = Options()
  ) {
    self.init(
      predicates: predicates,
      compound: compound,
      options: options
    )
  }

  init(
    propertyName: String,
    _ comparison: Predicate.Comparison,
    _ value: any CustomStringConvertible,
    options: Options = Options()
  ) {
    self.init(
      predicates: [Predicate(property: propertyName, comparison: comparison, value: value)],
      options: options
    )
  }

  init(
    _ model: T,
    options: Options = Options()
  ) where T: Queryable & Identifiable, T.ID: CustomStringConvertible {
    self.init(\.id, .eq, model.id, options: options)
  }

  init(
    _ property: PartialKeyPath<T>,
    _ comparison: Predicate.Comparison,
    _ value: any CustomStringConvertible,
    options: Options = Options()
  ) where T: Queryable {
    if let predicate = Predicate(property, comparison, value) {
      self.init(predicates: [predicate], options: options)
    } else {
      self.init(false, options: options)
    }
  }
}
