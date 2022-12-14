// Created by Leopold Lemmermann on 19.12.22.

import Combine

extension AnyPublisher where Failure == Error {
  init(_ priority: TaskPriority? = nil, operation: @escaping () async throws -> Output) {
    self.init(Future(priority, operation: operation))
  }
  
  init(_ priority: TaskPriority? = nil, operation: @escaping (PassthroughSubject<Output, Error>) async throws -> Void) {
    self.init(PassthroughSubject(priority, operation: operation))
  }
}

extension Future where Failure == Error {
  convenience init(_ priority: TaskPriority? = nil, operation: @escaping () async throws -> Output) {
    self.init { fulfill in
      Task(priority: priority) {
        do { fulfill(.success(try await operation())) } catch { fulfill(.failure(error)) }
      }
    }
  }
}

extension PassthroughSubject where Failure == Error {
  convenience init(
    _ priority: TaskPriority? = nil, operation: @escaping (PassthroughSubject<Output, Error>) async throws -> Void
  ) {
    self.init()

    Task(priority: priority) {
      do {
        try await operation(self)
        send(completion: .finished)
      } catch {
        send(completion: .failure(error))
      }
    }
  }
}
