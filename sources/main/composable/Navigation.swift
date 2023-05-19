// Created by Leopold Lemmermann on 25.12.22.

import ComposableArchitecture
import LeosMisc

struct Navigation: ReducerProtocol {
  @Dependency(\.keyValueStorageService) var kvsService
  
  struct State: Equatable {
    var page: MainPage
    var detail: MainDetail
  }
  
  enum Action {
    case setPage(MainPage), setDetail(MainDetail)
    case loadPage, loadDetail
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .setPage(page):
      state.page = page
      kvsService.store(state.page, for: "current-page")
    case let .setDetail(detail):
      state.detail = detail
      kvsService.store(state.detail, for: "current-detail")
    case .loadPage:
      state.page ?= kvsService.load(for: "current-page")
    case .loadDetail:
      state.detail ?= kvsService.load(for: "current-detail")
    }
    
    return .none
  }
}
