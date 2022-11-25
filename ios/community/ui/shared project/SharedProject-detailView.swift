//	Created by Leopold Lemmermann on 24.10.22.

import AuthenticationService
import LeosMisc
import Previews
import SwiftUI

extension SharedProject {
  func detailView() -> some View { DetailView(self) }

  struct DetailView: View {
    let project: SharedProject

    var body: some View {
      List {
        project.itemsSectionView()
        project.commentsSectionView()
      }
      .title(project.label)
      .toolbar {
        ToolbarItem(placement: .bottomBar) { Text("POSTED_BY \(project.owner)") }
      }
      .toolbar(.visible, for: .navigationBar)
    }

    @EnvironmentObject private var mainState: MainState
    @State private var user: User?

    init(_ project: SharedProject) { self.project = project }
  }
}

extension SharedProject.DetailView {
  func updateUser(_ change: MainState.Change) {
    if case let .user(user) = change {
      self.user = user
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SharedProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        SharedProject.DetailView(.example)
          .previewDisplayName("Bare")

        SharedProject.DetailView(.example)
          .previewInSheet()
      }
      .configureForPreviews()
    }
  }
#endif
