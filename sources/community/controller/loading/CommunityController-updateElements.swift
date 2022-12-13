// Created by Leopold Lemmermann on 14.12.22.

import Concurrency
import DatabaseService
import SwiftUI
import Errors

extension CommunityController {
  func updateElements<T: DatabaseObjectConvertible>(
    on event: DatabaseEvent, by predicate: (T) -> Bool, into elements: Binding<LoadingState<T>>
  ) async -> Bool {
    await printError {
      switch event {
      case let .inserted(type, id) where type == T.self:
        if
          let id = id as? T.ID,
          let element: T = try await databaseService.fetch(with: id),
          predicate(element)
        {
          insert(element, into: &elements.wrapped.wrappedValue)
        }
      case let .deleted(type, id) where type == T.self:
        if let id = id as? T.ID { remove(with: id, from: &elements.wrapped.wrappedValue) }
      case let .status(status) where status == .unavailable:
        break
      case .status, .remote:
        return true
      default:
        break
      }
      
      return false
    } ?? false
  }
}
