//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct SharedProjectsList: View {
  let projectsWithOwner: (own: [Project.Shared.WithOwner]?, others: [Project.Shared.WithOwner])

  var body: some View {
    if let ownProjects = projectsWithOwner.own {
      Section("OWN_USERS_PROJECTS") {
        ForEach(ownProjects, content: \.row)
          .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
      }
    }

    Section("OTHER_USERS_PROJECTS") {
      ForEach(projectsWithOwner.others, content: \.row)
        .replaceIfEmpty(with: "NO_PROJECTS_PLACEHOLDER")
    }
  }

  init(_ projectsWithOwner: [Project.Shared.WithOwner], userID: User.ID?) {
    self.projectsWithOwner = userID
      .flatMap { userID in
        projectsWithOwner.partitioning { $0.owner.id != userID }
      } ?? (nil, projectsWithOwner)
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SharedProjectsList_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        List {
          SharedProjectsList([.init(.example, owner: .example)], userID: User.example.id)
        }
        .previewDisplayName("With User")
        
        List {
          SharedProjectsList([.init(.example, owner: .example)], userID: nil)
        }
        .previewDisplayName("Without User")
      }
      .configureForPreviews()
    }
  }
#endif
