//	Created by Leopold Lemmermann on 25.10.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension View {
  func loadConvertibles<T: DatabaseObjectConvertible & Codable & Equatable>(
    matchedBy query: Query<T>, into binding: Binding<[T]>, using service: any DatabaseService, cacheID: String? = nil
  ) -> some View {
    modifier(ConvertiblesLoader(matchedBy: query, into: binding, using: service, cacheID: cacheID))
  }
}

struct ConvertiblesLoader<T: DatabaseObjectConvertible & Codable & Equatable>: ViewModifier {
  @Binding var binding: [T]
  let service: any DatabaseService
  let query: Query<T>
  
  func body(content: Content) -> some View {
    content
      .onChange(of: query, perform: load)
      .onChange(of: elements) { binding ?= $0.wrapped }
    #if os(iOS)
      .animation(.default, value: elements)
    #endif
      .onAppear {
        load(query)
        update()
      }
  }

  @ObjectSceneStorage private var elements: LoadingState<T>
  
  private let tasks = Tasks()
  
  init(
    matchedBy query: Query<T> = Query(true),
    into binding: Binding<[T]>,
    using service: any DatabaseService,
    cacheID: String? = nil
  ) {
    (self.service, self.query) = (service, query)
    _binding = binding
    _elements = ObjectSceneStorage(wrappedValue: .idle, cacheID ?? UUID().uuidString)
  }
  
  private func load(_ query: Query<T>) {
    tasks["loadElements"] = Task(priority: .userInitiated) {
      await printError {
        for try await projects in try await service.fetch(query) { elements.add(projects) }
        elements.finish { _ in }
      }
    }
  }
    
  private func update() {
    tasks["updateElements"] = Task(priority: .userInitiated) {
      for await event in service.events {
        await printError {
          switch event {
          case let .inserted(type, id) where type == T.self:
            if let id = id as? T.ID, let element: T = try await service.fetch(with: id), query.evaluate(element) {
              insert(element)
            }
          case let .deleted(type, id) where type == T.self:
            if let id = id as? T.ID, let index = elements.wrapped?.index(ofElementWith: id) {
              elements.wrapped?.remove(at: index)
            }
          case let .status(status) where status == .unavailable:
            break
          case .status, .remote:
            load(query)
          default:
            break
          }
        }
      }
    }
  }
  
  private func insert(_ element: T) {
    if let index = elements.wrapped?.index(ofElementWith: element.id) {
      elements.wrapped?[index] = element
    } else {
      elements.wrapped?.append(element)
    }
  }
}
