//	Created by Leopold Lemmermann on 29.10.22.

import Combine

extension Future {
  func wait() async throws -> Output {
    try await self.value
  }
}

extension Future where Failure == Never {
  func wait() async -> Output {
    await self.value
  }
}
