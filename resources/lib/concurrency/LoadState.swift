//	Created by Leopold Lemmermann on 25.10.22.

enum LoadState<T> {
  case idle,
       loading([T]),
       loaded([T] = []),
       failed(Error?)
}

extension LoadState: Equatable where T: Equatable {
  static func == (lhs: LoadState<T>, rhs: LoadState<T>) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case let (.loading(lhsItems), .loading(rhsItems)):
      return rhsItems == lhsItems
    case let (.loaded(lhsItems), .loaded(rhsItems)):
      return rhsItems == lhsItems
    default:
      return false
    }
  }
}

extension LoadState {
  mutating func add(elements: T...) { add(elements: elements) }
  mutating func add(elements: [T]) {
    switch self {
    case let .loading(array):
      self = .loading(array + elements)
    case .loaded:
      self = .loading(elements)
    default:
      self = .loading(elements)
    }
  }

  mutating func update(elements: T...) { update(elements: elements) }
  mutating func update(elements: [T]) {
    switch self {
    case .loading:
      self = .loading(elements)
    case .loaded:
      self = .loaded(elements)
    default:
      self = .loading(elements)
    }
  }

  mutating func setLoaded() {
    if case let .loading(array) = self {
      self = .loaded(array)
    } else {
      self = .loaded()
    }
  }
}
