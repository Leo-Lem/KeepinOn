//	Created by Leopold Lemmermann on 25.10.22.

import LeosMisc
import DatabaseService
import AuthenticationUI
import Errors
import SwiftUI
import CoreHapticsService
import ComposableArchitecture

extension Project {
  struct PublishingMenu: View {
    let isPublished: Bool?
    let hasiCloud: Bool, isLoggedIn: Bool
    let publish: () async throws -> Void, unpublish: () async throws -> Void

    var body: some View {
      EmptyView().waitFor(isPublished) { isPublished in
        AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
          guard hasiCloud else { return isShowingFeedback = true }
          await printError {
            do {
              try await publish()
              hapticsService?.play(.taDa)
            } catch let error as DatabaseError where error.hasDescription { self.error = error }
          }
        } label: {
          isPublished ?
            Label("REPUBLISH_PROJECT", systemImage: "arrow.clockwise.icloud") :
            Label("PUBLISH_PROJECT", systemImage: "icloud.and.arrow.up")
        }
        .if(isLoggedIn) { $0
          .alert("CANT_CONNECT_TO_ICLOUD_TITLE", isPresented: $isShowingFeedback) {} message: {
            Text("CANT_CONNECT_TO_ICLOUD_MESSAGE")
          }
        } else: { $0
          .popover(isPresented: $isShowingFeedback) { AuthenticationView(service: authService) }
        }

        if isPublished {
          AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) {
            guard hasiCloud else { return isShowingFeedback = true }

            await printError {
              do {
                try await unpublish()
              } catch let error as DatabaseError where error.hasDescription { self.error = error }
            }
          } label: {
            Label("UNPUBLISH_PROJECT", systemImage: "xmark.icloud")
          }
          .alert(isPresented: Binding(item: $error), error: error) {}
        }
      }
      .animation(.default, value: isPublished)
      .accessibilityElement(children: .contain)
    }

    @State private var isShowingFeedback = false
    @State private var error: DatabaseError?
    @State private var hapticsService = CoreHapticsService()
    @Dependency(\.authenticationService) private var authService
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct PublishingMenu_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Project.PublishingMenu(isPublished: false, hasiCloud: true, isLoggedIn: true) {} unpublish: {}
        .previewDisplayName("Not published")

      Project.PublishingMenu(isPublished: false, hasiCloud: false, isLoggedIn: false) {} unpublish: {}
        .previewDisplayName("Not published, not logged in")

      Project.PublishingMenu(isPublished: false, hasiCloud: false, isLoggedIn: true) {} unpublish: {}
        .previewDisplayName("Not published, logged in, no iCloud")

      List { Project.PublishingMenu(isPublished: true, hasiCloud: true, isLoggedIn: true) {} unpublish: {} }
        .previewDisplayName("Published")

      List {
        Project.PublishingMenu(isPublished: true, hasiCloud: true, isLoggedIn: true) {
          throw DatabaseError.status(.unavailable)
        } unpublish: {
          throw DatabaseError.status(.unavailable)
        }
      }
      .previewDisplayName("Published, error during publishing and unpublishing")
    }
    .presentPreview()
  }
}
#endif
