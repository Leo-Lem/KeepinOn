// Created by Leopold Lemmermann on 14.12.22.

import Concurrency
import DatabaseService
import SwiftUI

extension CommunityController {
  func loadElements<T: DatabaseObjectConvertible>(query: Query<T>, into elements: Binding<LoadingState<T>>) async {
    do {
      for try await projects in try await databaseService.fetch(query) { elements.wrappedValue.add(projects) }
      elements.wrappedValue.finish {}
    } catch {
      elements.wrappedValue.finish { throw error }
    }
  }
}
