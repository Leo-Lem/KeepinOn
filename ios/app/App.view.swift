import Concurrency
import CoreSpotlightService
import Errors
import LeosMisc
import SwiftUI

struct AppView: View {
  @EnvironmentObject private var mainState: MainState

  var body: some View {
    Group {
      TabView(selection: $page) {
        ForEach(Page.allCases, id: \.self) { tab in
          NavigationStack(root: tab.view)
            .tag(tab)
            .tabItem { Label(LocalizedStringKey(tab.label), systemImage: tab.icon) }
        }
      }
      .onContinueUserActivity(CoreSpotlightService.activityType, perform: showSpotlightModel)
      .sheet($sheet)
    }
    .banner($banner)
    .alert($alert)
    .font(.default())
    .task {
      tasks.add(mainState.didChange.getTask(.userInitiated, operation: updateView))
    }
  }

  @AppStorage("currentPage") private var page: Page = .home
  @State private var sheet: Sheet?
  @State private var banner: Banner?
  @State private var alert: Alert?

  private let tasks = Tasks()
}

private extension AppView {
  func showSpotlightModel(_ activity: NSUserActivity) {
    guard let id = (activity.userInfo?[CoreSpotlightService.activityID] as? String).flatMap(UUID.init) else { return }

    let service = mainState.localDBService

    printError {
      if let item: Item = try service.fetch(with: id) {
        sheet = .item(item)
      } else if let project: Project = try service.fetch(with: id) {
        sheet = .project(project)
      }
    }
  }

  func updateView(_ change: MainState.Change) {
    switch change {
    case let .page(newPage):
      page = newPage
    case let .sheet(newSheet):
      sheet = newSheet
    case let .banner(newBanner):
      banner = newBanner
    case let .alert(newAlert):
      alert = newAlert
    default: break
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct AppView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        AppView()
      }
      .configureForPreviews()
    }
  }
#endif
