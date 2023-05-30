// Created by Leopold Lemmermann on 30.05.2023.

import ComposableArchitecture
import SwiftUI
import struct Projects.ProjectsView

struct AppView: View {
  @EnvironmentObject private var store: StoreOf<AppReducer>

  var body: some View {
    WithViewStore(store) { vs in
      Render()
        .environmentObject(store.scope(state: \.projects, action: { .projects($0) }))
    }
  }
}

// MARK: - (RENDER)

extension AppView {
  struct Render: View {
    var body: some View {
      ProjectsView()
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct AppView_Previews: PreviewProvider {
    static var previews: some View {
      AppView.Render()
    }
  }
#endif
