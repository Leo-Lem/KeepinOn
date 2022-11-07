//	Created by Leopold Lemmermann on 29.10.22.

import Combine
import Foundation

extension Publisher {
  func getTask(with action: @escaping (Output) async throws -> Void) -> Task<Void, Error> {
    Task(priority: .background) {
      try await updateOnChange(with: action)
    }
  }

  func updateOnChange(with action: @escaping (Output) async throws -> Void) async throws {
    for try await output in self.values {
      try await action(output)
    }
  }
}

extension Publisher where Failure == Never {
  func getTask(with action: @escaping (Output) async -> Void) -> Task<Void, Never> {
    Task(priority: .background) {
//      await updateOnChange(with: action)
      for await output in self.values {
        await action(output)
      }
    }
  }

//  func updateOnChange(with action: @escaping (Output) async -> Void) async {
//    for await output in self.values {
//      await action(output)
//    }
//  }
}
