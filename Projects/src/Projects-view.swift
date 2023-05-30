// Created by Leopold Lemmermann on 30.05.2023.

import ComposableArchitecture
import SwiftUI

public struct ProjectsView: View {
  @EnvironmentObject var store: StoreOf<Projects>

  public var body: some View {
    WithViewStore(store) { vs in
      // TODO: configure Projects view
      Render()
    }
  }

  public init() {}
}

extension Store: ObservableObject {} // pass store as environment object

// MARK: - (RENDER)

extension ProjectsView {
  struct Render: View {
    var body: some View {
      Text("Projects") // TODO: implement Projects render view
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
      ProjectsView.Render()
    }
  }
#endif
