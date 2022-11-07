//	Created by Leopold Lemmermann on 29.10.22.

import Combine

extension Publisher {
  func useValues(_ receive: (Output) async -> Void, finally: () async -> Void = {}) async throws {
    for try await element in values {
      await receive(element)
    }

    await finally()
  }
}
