// Created by Leopold Lemmermann on 22.02.25.

import ComposableArchitecture
import Data
import SwiftUIComponents

public struct FeaturedView: View {
  public var store: StoreOf<Featured>

  public var body: some View {
    VStack {
      FeaturedProjects(store.projects)
      FeaturedItems(store.items)
        .padding(.horizontal)
    }
    .transition(.move(edge: .top).combined(with: .opacity))
    .animation(.default, value: store.projects)
    .animation(.default, value: store.items)
  }

  public init(_ store: StoreOf<Featured>) { self.store = store }
}

#Preview {
  let (_, _) = previews()
  FeaturedView(Store(initialState: Featured.State()) { Featured()._printChanges() })
}
