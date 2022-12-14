//	Created by Leopold Lemmermann on 07.10.22.

import ComposableArchitecture
import Queries
import LeosMisc
import SwiftUI

struct FeedView: View {
  var body: some View {
    WithViewStore<ViewState, ViewAction, _>(store) { state in
      ViewState(
        projects: state.publicDatabase.projects.convertibles(matching: query),
        userID: state.account.id
      )
    } send: { action in
      switch action {
      case .load: return .publicDatabase(.projects(.loadFor(query: query)))
      case .loadUserID: return .account(.loadID)
      }
    } content: { vm in
      Render(vm.projects, id: vm.userID)
        .task {
          await vm.send(.loadUserID).finish()
          vm.send(.load)
        }
    }
  }
  
  @EnvironmentObject private var store: StoreOf<MainReducer>
  private let query = Query<SharedProject>(true, options: .init(batchSize: 5))
  
  struct ViewState: Equatable {
    var projects: [SharedProject]
    var userID: User.ID?
  }
  
  enum ViewAction { case load, loadUserID }

  struct Render: View {
    let projects: [SharedProject]
    let id: User.ID?

    var body: some View {
      List {
        if let id {
          let projects: (own: _, others: _) = projects.splitting { $0.owner == id }

          Section("OWN_USERS_PROJECTS") { projectsList(projects.own) }
          Section("OTHER_USERS_PROJECTS") { projectsList(projects.others) }
        } else {
          Section("") { projectsList(projects) }
        }
      }
    }

    init(_ projects: [SharedProject], id: User.ID?) { (self.projects, self.id) = (projects, id) }

    private func projectsList(_ projects: [SharedProject]) -> some View {
      ForEach(projects, content: SharedProject.RowView.init)
        .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FeedView.Render([.example, .example, .example], id: nil)
        .previewDisplayName("Without User ID")

      let id = User.example.id
      FeedView.Render([SharedProject(.example, owner: id), .example, .example, .example], id: id)
        .previewDisplayName("With User ID")
    }
    .presentPreview()
  }
}
#endif
