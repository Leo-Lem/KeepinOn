//	Created by Leopold Lemmermann on 30.10.22.

infix operator ???: NilCoalescingPrecedence
extension StringProtocol {
  /// Works like nil coalescing for empty strings.
  static func ???<S: StringProtocol>(string: Self, replaceWith: S) -> Self {
    string.replaceIfEmpty(with: replaceWith)
  }

  func replaceIfEmpty<S: StringProtocol>(with other: S) -> Self {
    self.isEmpty ? Self(stringLiteral: other.description) : self
  }
}
