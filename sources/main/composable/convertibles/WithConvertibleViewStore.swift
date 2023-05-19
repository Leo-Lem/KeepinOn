// Created by Leopold Lemmermann on 19.12.22.

import ComposableArchitecture
import DatabaseService
import SwiftUI

struct WithConvertibleViewStore<T: DatabaseObjectConvertible & Hashable, Content: View>: View {
  let id: T.ID
  let statePath: StatePath, actionPath: ActionPath
  let content: CreateContent

  var body: some View {
    WithViewStore(store) {
      ViewState(convertible: $0.convertible(with: id))
    } send: { (_: ViewAction) in
      .loadWith(id: id)
    } content: { vm in
      content(vm.convertible)
        .animation(.default, value: vm.convertible)
        .task { await vm.send(.load).finish() }
    }
  }

  @EnvironmentObject private var mainStore: StoreOf<MainReducer>
  private var store: StoreOf<Convertible<T>> {
    mainStore.scope { $0[keyPath: statePath] } action: { action in actionPath.embed(action) }
  }

  init(
    with id: T.ID, from statePath: StatePath, loadWith actionPath: ActionPath,
    @ViewBuilder content: @escaping CreateContent
  ) {
    (self.id, self.statePath, self.actionPath) = (id, statePath, actionPath)
    self.content = content
  }

  struct ViewState: Equatable { var convertible: T? }
  enum ViewAction { case load }
  typealias StatePath = KeyPath<MainReducer.State, Convertible<T>.State>
  typealias ActionPath = CasePath<MainReducer.Action, Convertible<T>.Action>
  typealias CreateContent = (T?) -> Content
}
