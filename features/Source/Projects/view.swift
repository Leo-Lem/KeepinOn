// Created by Leopold Lemmermann on 20.02.25.

import ComposableArchitecture
import Data
import SwiftUI

@ViewAction(for: Projects.self)
public struct ProjectsView: View {
  @Bindable public var store: StoreOf<Projects>

  public var body: some View {
    Text("Hello, World!")
      .onAppear { send(.appear) }
  }

  public init(_ store: StoreOf<Projects>) { self.store = store }
}

#Preview {
  ProjectsView(Store(initialState: Projects.State()) { Projects()._printChanges() })
    .onAppear { SwiftDatabase.start() }
}
