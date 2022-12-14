// Created by Leopold Lemmermann on 19.12.22.

import ComposableArchitecture
import DatabaseService
import Queries
import SwiftUI

struct WithConvertiblesViewStore<T: DatabaseObjectConvertible & Hashable, Content: View>: View {
  let query: Query<T>
  let statePath: StatePath
  let actionPath: ActionPath
  let content: ([T]) -> Content

  var body: some View {
    WithViewStore<ViewState, ViewAction, _>(store) {
      ViewState(convertibles: $0.convertibles(matching: query))
    } send: { _ in
      .loadFor(query: query)
    } content: { vm in
      content(vm.convertibles)
        .animation(.default, value: vm.convertibles)
        .task { await vm.send(.load).finish() }
    }
  }

  @EnvironmentObject private var mainStore: StoreOf<MainReducer>
  private var store: StoreOf<Convertible<T>> {
    mainStore.scope { $0[keyPath: statePath] } action: { action in actionPath.embed(action) }
  }

  init(
    matching query: Query<T>,
    from statePath: StatePath,
    loadWith actionPath: ActionPath,
    @ViewBuilder content: @escaping ([T]) -> Content
  ) {
    (self.query, self.statePath, self.actionPath, self.content) = (query, statePath, actionPath, content)
  }

  struct ViewState: Equatable { var convertibles: [T] }
  enum ViewAction { case load }
  typealias StatePath = KeyPath<MainReducer.State, Convertible<T>.State>
  typealias ActionPath = CasePath<MainReducer.Action, Convertible<T>.Action>
}
