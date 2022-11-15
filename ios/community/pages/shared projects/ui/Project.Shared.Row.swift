//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Project.Shared.WithOwner {
  var row: some View { Project.Shared.Row(self)}
}

extension Project.Shared {
  struct Row: View {
    let projectWithOwner: Project.Shared.WithOwner
    
    var body: some View {
      SheetLink(.sharedProject(project)) {
        VStack(alignment: .leading) {
          Text(project.label)
            .font(.default(.headline))
          Text(owner.label)
            .foregroundColor(owner.color)
        }
      }
    }
    
    private var project: Project.Shared { projectWithOwner.project }
    private var owner: User { projectWithOwner.owner }
    
    init(_ projectWithOwner: Project.Shared.WithOwner) {
      self.projectWithOwner = projectWithOwner
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedProjectRow_Previews: PreviewProvider {
  static var previews: some View {
    Project.Shared.Row(.init(.example, owner: .example))
      .configureForPreviews()
  }
}
#endif
