// Created by Leopold Lemmermann on 20.12.22.

import AuthenticationUI
import ComposableArchitecture
import CoreHapticsService
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension Project {
  struct PublishMenu: View {
    let id: Project.ID

    var body: some View {
      WithConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) {
        Unwrap($0) { project in
          WithConvertiblesViewStore(
            matching: .init(\.project, id),
            from: \.privateDatabase.items,
            loadWith: .init { .privateDatabase(.items($0)) }
          ) { items in
            WithAccountViewStore { currentUserID, canPublish in
              WithViewStore(store) {
                $0.publicDatabase.projects.convertible(with: id) != nil
              } send: { (action: ViewAction) in
                switch action {
                case .load: return .publicDatabase(.projects(.loadWith(id: id)))
                case let .publishProject(id): return .publicDatabase(.projects(.add(SharedProject(project, owner: id))))
                case let .publishItem(item): return .publicDatabase(.items(.add(SharedItem(item))))
                case .unpublish: return .publicDatabase(.projects(.deleteWith(id: id)))
                }
              } content: { store in
                Render(isPublished: store.state, hasiCloud: canPublish, isLoggedIn: currentUserID != nil) {
                  if let id = currentUserID {
                    for item in items { await store.send(.publishItem(item)).finish() }
                    await store.send(.publishProject(id)).finish()
                  }
                } unpublish: {
                  await store.send(.unpublish).finish()
                }
              }
            }
          }
        }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>

    enum ViewAction { case load, publishProject(User.ID), publishItem(Item), unpublish }

    struct Render: View {
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
}

// MARK: - (PREVIEWS)

#if DEBUG
struct PublishingMenu_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Project.PublishMenu.Render(isPublished: false, hasiCloud: true, isLoggedIn: true) {} unpublish: {}
        .previewDisplayName("Not published")

      Project.PublishMenu.Render(isPublished: false, hasiCloud: false, isLoggedIn: false) {} unpublish: {}
        .previewDisplayName("Not published, not logged in")

      Project.PublishMenu.Render(isPublished: false, hasiCloud: false, isLoggedIn: true) {} unpublish: {}
        .previewDisplayName("Not published, logged in, no iCloud")

      List {
        Project.PublishMenu.Render(isPublished: true, hasiCloud: true, isLoggedIn: true) {} unpublish: {}
      }
        .previewDisplayName("Published")

      List {
        Project.PublishMenu.Render(isPublished: true, hasiCloud: true, isLoggedIn: true) {
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
