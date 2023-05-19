// Created by Leopold Lemmermann on 25.12.22.

import ComposableArchitecture
import SwiftUI

struct WithPresentationViewStore<Content: View>: View {
  let content: CreateContent

  var body: some View {
    WithViewStore(store) { vm in
      content(
        vm.binding(get: \.page) { .setPage($0) },
        vm.binding(get: \.detail) { .setDetail($0) }
      )
      .animation(.default, value: vm.state)
      .task {
        await vm.send(.loadPage).finish()
        await vm.send(.loadDetail).finish()
      }
    }
  }

  @EnvironmentObject private var mainStore: StoreOf<MainReducer>
  private var store: StoreOf<Navigation> {
    mainStore.scope(state: \.navigation) { MainReducer.Action.navigation($0) }
  }

  init(@ViewBuilder content: @escaping CreateContent) { self.content = content }
  
  typealias CreateContent = (Binding<MainPage>, Binding<MainDetail>) -> Content
}
