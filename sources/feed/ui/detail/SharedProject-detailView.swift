//	Created by Leopold Lemmermann on 24.10.22.

import Concurrency
import LeosMisc
import Queries
import SwiftUI
import ComposableArchitecture

extension SharedProject {
  func detailView() -> some View { DetailView(self) }

  struct DetailView: View {
    let project: SharedProject

    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(
          currentUserID: state.account.id,
          owner: state.publicDatabase.users.convertible(with: project.owner),
          items: state.publicDatabase.items.convertibles(matching: itemsQuery),
          comments: state.publicDatabase.comments.convertibles(matching: commentsQuery)
        )
      } send: { action in
        switch action {
        case .loadCurrentUserID: return .account(.loadID)
        case .loadOwner: return .publicDatabase(.users(.loadWith(id: project.owner)))
        case .loadItems: return .publicDatabase(.items(.loadFor(query: itemsQuery)))
        case .loadComments: return .publicDatabase(.comments(.loadFor(query: commentsQuery)))
        }
      } content: { vm in
        Render(project, owner: vm.owner, items: vm.items, comments: vm.comments, currentUserID: vm.currentUserID)
          .task {
            await vm.send(.loadCurrentUserID).finish()
            await vm.send(.loadOwner).finish()
            vm.send(.loadComments)
            vm.send(.loadItems)
          }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
    private var itemsQuery: Query<SharedItem> { Query(\.project, project.id, options: .init(batchSize: 5)) }
    private var commentsQuery: Query<Comment> { Query(\.project, project.id, options: .init(batchSize: 5)) }
    
    struct ViewState: Equatable { var currentUserID: User.ID?, owner: User?, items: [SharedItem], comments: [Comment] }
    enum ViewAction { case loadCurrentUserID, loadOwner, loadItems, loadComments }

    init(_ project: SharedProject) { self.project = project }

    struct Render: View {
      let project: SharedProject
      let owner: User?
      let items: [SharedItem]
      let comments: [Comment]
      let currentUserID: User.ID?

      var body: some View {
        VStack {
          HStack {
            project.peekView()

            if let owner, currentUserID != owner.id {
              Spacer()
              owner.peekButton().frame(height: 50)
            }
          }
          .padding()

          List {
            Section {
              ForEach(items) { $0.rowView() }.replaceIfEmpty(with: "NO_ITEMS_PLACEHOLDER")
            }

            Section {
              ForEach(comments) { $0.rowView() }.replaceIfEmpty(with: "NO_COMMENTS_IN_PROJECT_PLACEHOLDER")
            } header: {
              Text("COMMENTS_HEADER")
            } footer: {
              Comment.PostView(projectID: project.id)
            }
          }
          .scrollContentBackground(.hidden)
          .border(.top)
        }
        .accessibilityLabel("SHARED_PROJECT_TITLE")
        .accessibilityValue(project.label)
      }

      init(_ project: SharedProject, owner: User?, items: [SharedItem], comments: [Comment], currentUserID: User.ID?) {
        self.project = project
        (self.owner, self.items, self.comments) = (owner, items, comments)
        self.currentUserID = currentUserID
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedProjectDetailView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SharedProject.DetailView.Render(
        .example,
        owner: .example, items: [.example, .example, .example], comments: [.example, .example, .example],
        currentUserID: User.example.id
      )
      .presentPreview(inContext: true)
      
      let owner = User.example
      SharedProject.DetailView.Render(
        SharedProject(.example, owner: owner.id),
        owner: owner, items: [.example, .example, .example], comments: [.example, .example, .example],
        currentUserID: owner.id
      )
      .presentPreview(inContext: true)
      .previewDisplayName("Current user is owner")
    }
  }
}
#endif
