//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct SharedProjectsList: View {
  let projects: [Project.Shared],
      user: User?

  var body: some View {
    if let user = user {
      Section("OWN_USERS_PROJECTS") {
        let ownProjects = projects.filter { $0.owner?.id == user.id }
        if ownProjects.isEmpty {
          Text("NO_PROJECTS_PLACEHOLDER")
        } else {
          ForEach(ownProjects, content: SharedProjectRow.init)
        }
      }

      Section("OTHER_USERS_PROJECTS") {
        let othersProjects = projects.filter { $0.owner?.id != user.id }
        if othersProjects.isEmpty {
          Text("NO_PROJECTS_PLACEHOLDER")
        } else {
          ForEach(othersProjects, content: SharedProjectRow.init)
        }
      }
    } else {
      Section("SHARED_PROJECTS") {
        if projects.isEmpty {
          Text("NO_PROJECTS_PLACEHOLDER")
        } else {
          ForEach(projects, content: SharedProjectRow.init)
        }
      }
    }
  }

  init(_ projects: [Project.Shared], user: User?) {
    self.projects = projects
    self.user = user
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedProjectsList_Previews: PreviewProvider {
  static var previews: some View {
    SharedProjectsList([.example], user: .example)
      .previewDisplayName("With User")

    SharedProjectsList([.example], user: nil)
      .previewDisplayName("Without User")
  }
}
#endif
