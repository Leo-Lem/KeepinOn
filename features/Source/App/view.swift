// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Data
import Projects
import SwiftUI

public struct KeepinOnView: View {
  @Bindable var store: StoreOf<KeepinOn>

  public var body: some View {
    VStack {
      ProjectsView(store.scope(state: \.projects, action: \.projects))
    }
    .environment(\.font, Font.custom("American TypeWriter", size: 14))
  }

  public init(_ store: StoreOf<KeepinOn> = Store(initialState: KeepinOn.State(), reducer: KeepinOn.init)) {
      prepareDependencies {
        $0.defaultDatabase = try! database() // swiftlint:disable:this force_try
      }
    self.store = store
  }
}

#Preview {
  KeepinOnView()
}
