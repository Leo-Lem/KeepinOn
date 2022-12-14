//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI
import ComposableArchitecture

extension SharedProject {
  func rowView() -> some View { SharedProject.RowView(self) }

  struct RowView: View {
    let project: SharedProject

    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(currentUserID: state.account.id, owner: state.publicDatabase.users.convertible(with: project.owner))
      } send: { action in
        switch action {
        case .loadCurrentUserID: return .account(.loadID)
        case .loadOwner: return .publicDatabase(.users(.loadWith(id: project.owner)))
        }
      } content: { vm in
        Render(project, owner: vm.owner, currentUserID: vm.currentUserID)
          .task {
            await vm.send(.loadCurrentUserID).finish()
            await vm.send(.loadOwner).finish()
          }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>
    
    init(_ project: SharedProject) { self.project = project }
    
    struct ViewState: Equatable { var currentUserID: User.ID?, owner: User? }
    enum ViewAction { case loadCurrentUserID, loadOwner }

    struct Render: View {
      let project: SharedProject
      let owner: User?
      let currentUserID: User.ID?

      var body: some View {
        HStack {
          project.peekView()

          Spacer()

          if let owner, currentUserID != owner.id {
            Button { present(MainDetail.user(owner)) } label: {
              owner.avatarID.icon()
                .frame(height: 50)
                .foregroundColor(owner.color)
            }
          }
        }
        .buttonStyle(.borderless)
        .onTapGesture { present(MainDetail.sharedProject(project)) }
        .accessibilityLabel("A11Y_SHAREDPROJECT")
        .accessibilityValue(project.a11y(owner?.label))
      }

      @Environment(\.present) private var present

      init(_ project: SharedProject, owner: User?, currentUserID: User.ID?) {
        (self.project, self.owner, self.currentUserID) = (project, owner, currentUserID)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedProjectRow_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SharedProject.RowView.Render(.example, owner: .example, currentUserID: nil)

      let owner = User.example
      SharedProject.RowView.Render(.example, owner: owner, currentUserID: owner.id)
        .previewDisplayName("Current user is owner")

      List([SharedProject.example, .example, .example]) { project in
        SharedProject.RowView.Render(project, owner: .example, currentUserID: nil)
      }
      .previewDisplayName("List")
    }
    .presentPreview()
  }
}
#endif
