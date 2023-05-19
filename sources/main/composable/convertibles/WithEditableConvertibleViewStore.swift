// Created by Leopold Lemmermann on 25.12.22.

import ComposableArchitecture
import DatabaseService
import SwiftUI

struct WithEditableConvertibleViewStore<T: DatabaseObjectConvertible & Hashable, Content: View>: View {
  let id: T.ID
  let statePath: StatePath, actionPath: ActionPath
  let content: CreateContent

  var body: some View {
    WithViewStore(store) {
      ViewState(convertible: $0.convertible(with: id))
    } send: { (action: ViewAction) in
      switch action {
      case .load: return .loadWith(id: id)
      case let .modify(modification): return .modifyWith(id: id, modification: modification)
      }
    } content: { vm in
      content(vm)
        .animation(.default, value: vm.convertible)
        .task { await vm.send(.load).finish() }
    }
  }

  @EnvironmentObject private var mainStore: StoreOf<MainReducer>
  private var store: StoreOf<Convertible<T>> {
    mainStore.scope { $0[keyPath: statePath] } action: { action in actionPath.embed(action) }
  }

  init(
    with id: T.ID,
    from statePath: StatePath, loadWith actionPath: ActionPath,
    @ViewBuilder content: @escaping CreateContent
  ) {
    (self.id, self.statePath, self.actionPath, self.content) = (id, statePath, actionPath, content)
  }

  struct ViewState: Equatable { var convertible: T? }
  enum ViewAction {
    case load, modify(modification: (inout T) async -> Void)
    static func modify<U>(_ property: WritableKeyPath<T, U>, _ newValue: U) -> Self {
      .modify { $0[keyPath: property] = newValue }
    }
  }
  typealias StatePath = KeyPath<MainReducer.State, Convertible<T>.State>
  typealias ActionPath = CasePath<MainReducer.Action, Convertible<T>.Action>
  typealias CreateContent = (ViewStore<ViewState, ViewAction>) -> Content
}
