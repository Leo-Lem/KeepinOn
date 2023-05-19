//	Created by Leopold Lemmermann on 07.12.22.

import ComposableArchitecture
import CoreHapticsService
import InAppPurchaseUI
import LeosMisc
import SwiftUI

extension Project {
  struct ToggleMenu: View {
    let id: Project.ID
    let feedback: [Feedback]

    var body: some View {
      WithEditableConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { editable in
        Unwrap(editable.convertible) { (project: Project) in
          WithPresentationViewStore { page, detail in
            WithViewStore(store, observe: \.projectLimitIsReached) { projectLimitIsReached in
              Render(
                isClosed: project.isClosed, limitIsReached: projectLimitIsReached.state, feedback: feedback,
                setPage: { page.wrappedValue = $0 },
                dismiss: { detail.wrappedValue = .empty },
                toggle: { await editable.send(.modify(\.isClosed, !project.isClosed)).finish() }
              )
            }
          }
        }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>
    enum Feedback: Equatable { case haptic, changePage, dismiss }

    struct Render: View {
      let isClosed: Bool
      let limitIsReached: Bool
      let feedback: [Feedback]
      let setPage: (MainPage) -> Void, dismiss: () -> Void, toggle: () async -> Void

      var body: some View {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          if isClosed, limitIsReached { return isPurchasing = true }

          await toggle()

          if feedback.contains(.dismiss) { dismiss() }
          if feedback.contains(.changePage) { setPage(isClosed ? .open : .closed) }
          if isClosed, feedback.contains(.haptic) { hapticsService?.play(.taDa) }
        } label: {
          isClosed ?
            Label("REOPEN_PROJECT", systemImage: "lock.open") :
            Label("CLOSE_PROJECT", systemImage: "lock")
        }
        .accessibilityLabel("toggle-project")
        .popover(isPresented: $isPurchasing) { InAppPurchaseView(id: .fullVersion, service: iapService) }
      }

      @State private var isPurchasing = false
      @State private var hapticsService = CoreHapticsService()
      @Dependency(\.inAppPurchaseService) private var iapService
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectToggleMenu_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Project.ToggleMenu.Render(isClosed: false, limitIsReached: false, feedback: []) { _ in } dismiss: {} toggle: {}
      Project.ToggleMenu.Render(isClosed: true, limitIsReached: false, feedback: []) { _ in } dismiss: {} toggle: {}
        .previewDisplayName("Closed")
      Project.ToggleMenu.Render(isClosed: true, limitIsReached: true, feedback: []) { _ in } dismiss: {} toggle: {}
        .previewDisplayName("Limit reached")
    }
  }
}
#endif
