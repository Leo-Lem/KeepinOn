import Concurrency
import CoreSpotlightService
import Errors
import LeosMisc
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
    .banner(presenting: $mainState.presentation.banner, dismissAfter: .seconds(3)) { banner in
      switch banner {
      case let .awardEarned(award):
        award.earnedBanner()
          .onTapGesture {
            mainState.dismissPresentation(banner: true)
            mainState.showPresentation(.awards)
          }
      }
    }
    .font(.default())
    #if os(macOS)
    .buttonStyle(.borderless)
    #endif
  }

  @EnvironmentObject var mainState: MainState
  
#if os(iOS)
  @Environment(\.horizontalSizeClass) var hSize
#endif
  
  @MainActor func showSpotlightModel(for activity: NSUserActivity) async {
    guard let id = (activity.userInfo?[CoreSpotlightService.activityID] as? String).flatMap(UUID.init) else { return }

    await printError {
      if let item: Item = try await mainState.privateDBService.fetch(with: id) {
        mainState.showPresentation(detail: .item(item))
      } else if let project: Project = try await mainState.privateDBService.fetch(with: id) {
        mainState.showPresentation(detail: .project(project))
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct AppView_Previews: PreviewProvider {
    static var previews: some View {
      EntryView()
        .configureForPreviews()
    }
  }
#endif
