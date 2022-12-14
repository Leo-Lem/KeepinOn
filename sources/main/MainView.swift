import Concurrency
import CoreSpotlightService
import Errors
import LeosMisc
import SwiftUI

struct MainView: View {
  var body: some View {
    Group {
      switch size {
      case .regular: regularLayout()
      case .compact: compactLayout()
      }
    }
    .environment(\.present) { presented in
      switch presented {
      case let page as MainPage: self.page = page
      case let detail as MainDetail: self.detail = detail
      default: break
      }
    }
//    .onContinueUserActivity(CoreSpotlightService.activityType) { activity in
//      Task(priority: .userInitiated) { await showSpotlightModel(for: activity) }
//    }
    .banner(presenting: $banneredAward) { award in
      award.earnedBanner()
        .onTapGesture {
          banneredAward = nil
          page = .profile
          // TODO: route to awards page
//          detail = .awards(id: )
        }
    }
    .presentModal($spotlight.item, presented: spotlight.item ?? .example, content: Item.DetailView.init)
    .presentModal($spotlight.project, presented: spotlight.project ?? .example, content: Project.DetailView.init)
    .font(.default())
    .buttonStyle(.borderless)
#if os(macOS)
      .listStyle(.inset)
#endif
      .environment(\.size, size)
  }

  @AppStorage("currentPage") var page: MainPage = .home
  @State var detail: MainDetail = .empty
  @State var navCols: NavigationSplitViewVisibility = .all
  @State private var banneredAward: Award?
  @State private var spotlight: (item: Item?, project: Project?)

#if os(iOS)
  var size: SizeClass { hSize == .compact ? .compact : .regular }
  @Environment(\.horizontalSizeClass) private var hSize
#elseif os(macOS)
  let size = SizeClass.regular
#endif

//  @MainActor func showSpotlightModel(for activity: NSUserActivity) async {
//    guard let id = (activity.userInfo?[CoreSpotlightService.activityID] as? String).flatMap(UUID.init) else { return }
//
//    await printError {
//      if let item: Item = try await projectsController.databaseService.fetch(with: id) {
//        spotlight.item = item
//      } else if let project: Project = try await projectsController.databaseService.fetch(with: id) {
//        spotlight.project = project
//      }
//    }
//  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    MainView().presentPreview()
  }
}
#endif
