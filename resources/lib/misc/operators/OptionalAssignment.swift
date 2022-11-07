//	Created by Leopold Lemmermann on 07.10.22.

infix operator ?=: AssignmentPrecedence
extension Optional {
  /// Assigns the optional value only if it is not nil.
  static func ?= (
    assignTo: inout Wrapped,
    optional: Self
  ) {
    if let wrapped = optional {
      assignTo = wrapped
    }
  }
}
