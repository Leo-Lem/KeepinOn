//	Created by Leopold Lemmermann on 27.10.22.

import Combine

extension Future where Failure == Never {
  convenience init(operation: @escaping () async -> Output = {}) {
    self.init { promise in
      Task {
        let output = await operation()
        promise(.success(output))
      }
    }
  }
}

extension Future where Failure == Error {
  convenience init(operation: @escaping () async throws -> Output = {}) {
    self.init { promise in
      Task {
        do {
          let output = try await operation()
          promise(.success(output))
        } catch {
          promise(.failure(error))
        }
      }
    }
  }
}
