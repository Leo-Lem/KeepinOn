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
      if let store = $store.scope(state: \.featured, action: \.featured).wrappedValue {
        FeaturedView(store)

        Divider()
      }

      VStack {
        ProjectsList(store.scope(state: \.projects, action: \.projects))
      }
      .overlay(alignment: .top) {
        Capsule().frame(width: 50, height: 3)
          .onTapGesture { store.send(.toggleFeatured(store.featured == nil)) }
      }
    }
    .gesture(
      DragGesture(minimumDistance: 100)
        .onEnded { value in
          if value.translation.height > 100 {
            store.send(.toggleFeatured(true))
          } else if value.translation.height < -100 {
            store.send(.toggleFeatured(false))
          }
        }
    )
    .animation(.easeOut, value: store.featured)
    .environment(\.font, Font.custom("American TypeWriter", size: 14))
  }

  public init(
    _ store: StoreOf<KeepinOn>? = nil,
    database: (any DatabaseWriter)? = nil
  ) {
    prepareDependencies {
      $0.defaultDatabase = database ?? .keepinOn()
    }
    self.store = store ?? Store(initialState: KeepinOn.State()) { KeepinOn() }
  }
}

#Preview {
  KeepinOnView(database: .keepinOn(inMemory: true))
}
