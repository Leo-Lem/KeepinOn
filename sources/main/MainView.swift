import Concurrency
import ComposableArchitecture
import CoreSpotlightService
import Errors
import LeosMisc
import SwiftUI

struct MainView: View {
  var body: some View {
    WithViewStore(store) { state in
      ViewState(
        spotlightProject: spotlight.flatMap(state.privateDatabase.projects.convertible),
        spotlightItem: spotlight.flatMap(state.privateDatabase.items.convertible),
        page: state.navigation.page,
        detail: state.navigation.detail
      )
    } send: { (action: ViewAction) in
      switch action {
      case .loadPage: return .navigation(.loadPage)
      case .loadDetail: return .navigation(.loadDetail)
      case let .loadProject(id): return .privateDatabase(.projects(.loadWith(id: id)))
      case let .loadItem(id): return .privateDatabase(.items(.loadWith(id: id)))
      case let .setPage(page): return .navigation(.setPage(page))
      case let .setDetail(detail): return .navigation(.setDetail(detail))
      }
    } content: { vm in
      let page = vm.binding(get: \.page) { .setPage($0) }
      let detail = vm.binding(get: \.detail) { .setDetail($0) }
      
      Group {
        switch size {
        case .regular: regularLayout(page: page, detail: detail)
        case .compact: compactLayout(page: page, detail: detail)
        }
      }
      .task {
        await vm.send(.loadPage).finish()
        await vm.send(.loadDetail).finish()
      }
      .onChange(of: spotlight) { newSpotlightID in
        if let newSpotlightID {
          vm.send(.loadProject(newSpotlightID))
          vm.send(.loadItem(newSpotlightID))
        }
      }
      .onContinueUserActivity(CoreSpotlightService.activityType, perform: showSpotlight)
//      .banner(presenting: $banneredAward) { award in
//        award.earnedBanner()
//          .onTapGesture {
//            banneredAward = nil
//            vm.send(.setPage(.profile))
//            // TODO: route to awards page
//            detail = .awards(id: )
//          }
//      }
      .presentModal(Binding { spotlight != nil } set: { _ in spotlight = nil }) {
        if let project = vm.spotlightProject {
          Project.DetailView(id: project.id)
        } else if let item = vm.spotlightItem {
          Item.DetailView(id: item.id)
        }
      }
      .font(.default())
      .buttonStyle(.borderless)
  #if os(macOS)
        .listStyle(.inset)
  #endif
        .environment(\.size, size)
    }
  }
  
  @State var navCols: NavigationSplitViewVisibility = .all
  @State private var banneredAward: Award?
  @State private var spotlight: UUID?
  @EnvironmentObject private var store: StoreOf<MainReducer>

#if os(iOS)
  var size: SizeClass { hSize == .compact ? .compact : .regular }
  @Environment(\.horizontalSizeClass) private var hSize
#elseif os(macOS)
  let size = SizeClass.regular
#endif
  
  private func showSpotlight(for activity: NSUserActivity) {
    spotlight = (activity.userInfo?[CoreSpotlightService.activityID] as? String).flatMap(UUID.init)
  }
  
  struct ViewState: Equatable {
    var spotlightProject: Project?, spotlightItem: Item?
    var page: MainPage, detail: MainDetail
  }
  
  enum ViewAction {
    case loadPage, loadDetail
    case loadProject(Project.ID), loadItem(Item.ID)
    case setPage(MainPage), setDetail(MainDetail)
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    MainView().presentPreview()
  }
}
#endif
