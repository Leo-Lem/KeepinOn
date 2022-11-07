//	Created by Leopold Lemmermann on 17.10.22.

import CloudKit
import CoreData

extension NSPredicate {
  convenience init<T>(query: Query<T>) {
    var formatString = ""
    var values = [Any]()

    if let bool = query.bool {
      formatString = "\(bool ? "TRUE" : "FALSE")PREDICATE"
    } else if
      let predicates = query.predicates,
      let firstPredicate = predicates.first
    {
      formatString = Self.getFormatString(from: firstPredicate)
      values.append(firstPredicate.value)

      if let compound = query.compound {
        for predicate in predicates.dropFirst() {
          formatString += " \(Self.getCompoundSymbol(from: compound)) "
          formatString += Self.getFormatString(from: predicate)
          values.append(predicate.value)
        }
      }
    }

    self.init(format: formatString, argumentArray: values)
  }

  private static func getFormatString<T>(from predicate: Query<T>.Predicate) -> String {
    var formatString = "\(predicate.property) "
    formatString += "\(getComparisonSymbol(from: predicate.comparison)) "
    formatString += "\(getReplacementSymbol(for: predicate.value))"

    return formatString
  }

  private static func getComparisonSymbol<T>(from comparison: Query<T>.Predicate.Comparison) -> String {
    switch comparison {
    case .eq: return "=="
    case .neq: return "!="
    case .g: return ">"
    case .ge: return ">="
    case .l: return "<"
    case .le: return "<="
    }
  }

  private static func getReplacementSymbol<T>(for value: T) -> String {
    switch value {
    case is Bool, is Int: return "%d"
    default: return "%@"
    }
  }

  private static func getCompoundSymbol<T>(from compound: Query<T>.Compound) -> String {
    switch compound {
    case .and: return "AND"
    case .or: return "OR"
    }
  }
}
