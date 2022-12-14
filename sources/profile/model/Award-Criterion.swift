//	Created by Leopold Lemmermann on 06.11.22.

extension Award {
  enum Criterion {
    case items, complete, chat, unlock
    case unknown(_ value: String)
  }
}

extension Award.Criterion: CaseIterable {
  static let allCases = [Self.items, .complete, .chat, .unlock]
}

extension Award.Criterion: Codable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)

    self = {
      switch string {
      case "items": return .items
      case "complete": return .complete
      case "chat": return .chat
      case "unlock": return .unlock
      default: return .unknown(string)
      }
    }()
  }
}

extension Award.Criterion: Hashable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    if case let .unknown(lhsValue) = lhs, case let .unknown(rhsValue) = rhs {
      return lhsValue == rhsValue
    } else {
      switch (lhs, rhs) {
      case (.items, .items), (.complete, .complete), (.chat, .chat), (.unlock, .unlock): return true
      default: return false
      }
    }
  }
}
