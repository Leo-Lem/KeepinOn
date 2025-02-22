// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Data
import Featured
import Projects
import SwiftUIComponents

public struct KeepinOnView: View {
  @Bindable public var store: StoreOf<KeepinOn>

  public var body: some View {
    VStack {
      FeaturedView(store.scope(state: \.featured, action: \.featured))
      ProjectsList(store.scope(state: \.projects, action: \.projects))
    }
    .environment(\.font, Font.custom("American TypeWriter", size: 14))
  }

  public init(
    _ store: StoreOf<KeepinOn> = Store(initialState: KeepinOn.State()) { KeepinOn() },
    database: any DatabaseWriter = .keepinOn()
  ) {
      prepareDependencies {
        $0.defaultDatabase = database
      }
    self.store = store
  }
}

#Preview {
  KeepinOnView(database: .keepinOn(inMemory: true))
}
