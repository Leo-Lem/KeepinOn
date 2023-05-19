// Created by Leopold Lemmermann on 25.12.22.

import ComposableArchitecture
import SwiftUI

struct WithAccountViewStore<Content: View>: View {
  let content: CreateContent

  var body: some View {
    WithViewStore(store) { vm in
      content(vm.id, vm.canPublish)
        .animation(.default, value: vm.state)
        .task { await vm.send(.loadID).finish() }
    }
  }

  @EnvironmentObject private var mainStore: StoreOf<MainReducer>
  private var store: StoreOf<Account> {
    mainStore.scope(state: \.account) { MainReducer.Action.account($0) }
  }

  init(@ViewBuilder content: @escaping CreateContent) { self.content = content }

  typealias CreateContent = (_ currentUserID: User.ID?, _ canPublish: Bool) -> Content
}
