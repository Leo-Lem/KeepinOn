// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Projects
import SwiftUI

public struct KeepinOnView: View {
  @Bindable var store: StoreOf<KeepinOn>

  public var body: some View {
    ProjectsView(store.scope(state: \.projects, action: \.projects))
  }

  public init(_ store: StoreOf<KeepinOn> = Store(initialState: KeepinOn.State(), reducer: KeepinOn.init)) {
    self.store = store
  }
}

#Preview {
  KeepinOnView()
}
