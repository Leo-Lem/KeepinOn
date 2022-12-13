import Concurrency
import CoreSpotlightService
import Errors
import LeosMisc
import AwardsController
import SwiftUI

struct EntryView: View {
  var body: some View {
    Group {
      #if os(iOS)
        if hSize == .compact { compact } else { regular }
      #elseif os(macOS)
        regular
      #endif
    }
    .onContinueUserActivity(CoreSpotlightService.activityType) { activity in
      Task(priority: .userInitiated) { await showSpotlightModel(for: activity) }
    }
    .banner(presenting: $banneredAward) { award in
      award.earnedBanner()
        .onTapGesture {
          banneredAward = nil
          page = .awards
        }
    }
    .font(.default())
    .buttonStyle(.borderless)
    .onAppear {
      tasks["updateAward"] = awardsController.handleEventsTask(.high) { award in banneredAward = award }
    }
  }

  @AppStorage("currentPage") var page: Page = .home
  @State var detail: Detail?
  @State private var banneredAward: Award?
  private let tasks = Tasks()
  
  @EnvironmentObject private var projectsController: ProjectsController
  @EnvironmentObject private var awardsController: AwardsController
  
#if os(iOS)
  @Environment(\.horizontalSizeClass) var hSize
#endif
}

private extension EntryView {
  @MainActor func showSpotlightModel(for activity: NSUserActivity) async {
    guard let id = (activity.userInfo?[CoreSpotlightService.activityID] as? String).flatMap(UUID.init) else { return }

    await printError {
      if let item: Item = try await projectsController.databaseService.fetch(with: id) {
        detail = .item(item)
      } else if let project: Project = try await projectsController.databaseService.fetch(with: id) {
        detail = .project(project)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct AppView_Previews: PreviewProvider {
    static var previews: some View {
      EntryView()
    }
  }
#endif
