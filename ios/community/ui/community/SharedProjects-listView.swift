//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI
import LeosMisc

extension Array where Element == SharedProject {
  func listView(_ userID: User.ID?) -> some View { SharedProjectsListView(self, userID: userID) }
}

struct SharedProjectsListView: View {
  let projects: (own: [SharedProject]?, others: [SharedProject])

  var body: some View {
    if let ownProjects = projects.own {
      Section("OWN_USERS_PROJECTS") {
        ForEach(ownProjects, content: SharedProject.RowView.init)
          .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
      }
    }

    Section("OTHER_USERS_PROJECTS") {
      ForEach(projects.others, content: SharedProject.RowView.init)
        .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
    }
  }

  init(_ projects: [SharedProject], userID: User.ID?) {
    self.projects = userID
      .flatMap { userID in projects.partitioning { $0.owner != userID } } ??
      (nil, projects)
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SharedProjectsList_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        List { SharedProjectsListView([.example], userID: User.example.id) }
        .previewDisplayName("With User")

        List { [SharedProject.example].listView(nil) }
        .previewDisplayName("Without User")
      }
      .configureForPreviews()
    }
  }
#endif
