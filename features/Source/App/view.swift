// Created by Leopold Lemmermann on 19.02.25.

import ComposableArchitecture
import Data
import Projects
import SwiftUI

public struct KeepinOnView: View {
  @Bindable var store: StoreOf<KeepinOn>

  public var body: some View {
    VStack {
      ProjectsList(store.scope(state: \.projects, action: \.projects))
    }
    .environment(\.font, Font.custom("American TypeWriter", size: 14))
  }

  public init(
    _ store: StoreOf<KeepinOn> = Store(initialState: KeepinOn.State(), reducer: KeepinOn.init),
    database: any DatabaseWriter = .keepinOn()
  ) {
      prepareDependencies {
        $0.defaultDatabase = database
      }
    self.store = store
  }
}

#Preview {
  KeepinOnView(database: .keepinOn())
}
