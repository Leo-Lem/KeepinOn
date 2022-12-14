// Created by Leopold Lemmermann on 18.12.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension View {
  func loadConvertible<T: DatabaseObjectConvertible & Codable & Equatable>(
    with id: T.ID, into binding: Binding<T?>, using service: any DatabaseService
  ) -> some View {
    modifier(ConvertibleLoader(with: id, into: binding, using: service))
  }
}

struct ConvertibleLoader<T: DatabaseObjectConvertible & Codable & Equatable>: ViewModifier {
  @Binding var binding: T?
  let id: T.ID
  let service: any DatabaseService
  
  func body(content: Content) -> some View {
    content
      .task {}
      .onChange(of: id) { newID in
        Task(priority: .userInitiated) { await load(for: newID) }
      }
      .onChange(of: element) { newElement in binding = newElement }
      .animation(.default, value: element)
  }
  
  @ObjectSceneStorage private var element: T?
  
  private let tasks = Tasks()
  
  init(with id: T.ID, into binding: Binding<T?>, using service: any DatabaseService) {
    (self.id, self.service) = (id, service)
    _binding = binding
    _element = ObjectSceneStorage(wrappedValue: nil, id.description)
  }
  
  @MainActor private func load(for id: T.ID) async {
    await printError { element ?= try await service.fetch(with: id) }
  }
  
  private func update() {
    tasks["updateElement"] = service.handleEventsTask(.userInitiated) { event in
      await printError {
        switch event {
        case let .inserted(type, newID) where type == T.self && newID as? T.ID == id:
          element ?= try await service.fetch(with: id)
        case let .deleted(type, newID) where type == T.self && newID as? T.ID == id:
          element = nil
        case .remote:
          await load(for: id)
        default:
          break
        }
      }
    }
  }
}
