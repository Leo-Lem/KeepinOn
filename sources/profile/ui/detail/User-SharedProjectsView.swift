// Created by Leopold Lemmermann on 17.12.22.

import ComposableArchitecture
import LeosMisc
import Queries
import SwiftUI

extension User {
  struct SharedProjectsView: View {
    let currentUserID: User.ID

    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        let projects = state.publicDatabase.projects.convertibles(matching: projectsQuery)
        return ViewState(
          projects: projects,
          items: Array(projects.map(\.id).map(itemsQuery).map(state.publicDatabase.items.convertibles).joined()),
          comments:
          Array(projects.map(\.id).map(commentsQuery).map(state.publicDatabase.comments.convertibles).joined())
        )
      } send: { action in
        switch action {
        case .loadCurrentUserID:
          return .account(.loadID)
        case .loadProjects:
          return .publicDatabase(.projects(.loadFor(query: projectsQuery)))
        case let .loadItems(projectID):
          return .publicDatabase(.items(.loadFor(query: itemsQuery(for: projectID))))
        case let .loadComments(projectID):
          return .publicDatabase(.comments(.loadFor(query: commentsQuery(for: projectID))))
        }
      } content: { vm in
        Render(vm.projects, items: vm.items, comments: vm.comments)
          .task {
            await vm.send(.loadCurrentUserID).finish()
            await vm.send(.loadProjects).finish()
            for await projectID in vm.projects.map(\.id) {
              vm.send(.loadItems(projectID: projectID))
              vm.send(.loadComments(projectID: projectID))
            }
          }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>
    private var projectsQuery: Query<SharedProject> { Query(\.owner, currentUserID, options: .init(batchSize: 5)) }
    private func itemsQuery(for projectID: Project.ID) -> Query<SharedItem> {
      Query(\.project, projectID, options: .init(batchSize: 5))
    }

    private func commentsQuery(for projectID: Project.ID) -> Query<Comment> {
      Query(\.project, projectID, options: .init(batchSize: 5))
    }

    struct ViewState: Equatable { var projects: [SharedProject], items: [SharedItem], comments: [Comment] }
    enum ViewAction {
      case loadCurrentUserID, loadProjects, loadItems(projectID: Project.ID), loadComments(projectID: Project.ID)
    }

    struct Render: View {
      let projects: [SharedProject]
      let items: [SharedItem]
      let comments: [Comment]

      var body: some View {
        List(projects) { project in
          Section {
            // TODO: add items and comments
          } header: {
            project.peekView()
          }
        }
        .replace(if: projects.isEmpty, placeholder: "NO_PROJECTS_PLACEHOLDER")
#if os(iOS)
          .navigationTitle("YOUR_SHAREDPROJECTS_TITLE")
          .compactDismissButtonToolbar()
          .embedInNavigationStack()
#endif
      }

      init(_ projects: [SharedProject], items: [SharedItem], comments: [Comment]) {
        (self.projects, self.items, self.comments) = (projects, items, comments)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserSharedProjectsView_Previews: PreviewProvider {
  static var previews: some View {
    let projects = [SharedProject.example, .example, .example]
    let items = Array(projects.map { [
      SharedItem(Item(project: $0.id)),
      SharedItem(Item(project: $0.id)),
      SharedItem(Item(project: $0.id))
    ] }.joined())
    let comments = Array(projects.map { [
      Comment(content: "", project: $0.id, poster: User.example.id),
      Comment(content: "", project: $0.id, poster: User.example.id),
      Comment(content: "", project: $0.id, poster: User.example.id)
    ] }.joined())
    User.SharedProjectsView.Render([.example, .example, .example], items: items, comments: comments)
      .presentPreview(inContext: true)

    User.SharedProjectsView.Render([], items: [], comments: [])
      .presentPreview(inContext: true)
      .previewDisplayName("Empty")
  }
}
#endif
