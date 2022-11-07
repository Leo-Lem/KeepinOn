//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct SharedProjectRow: View {
  let project: Project.Shared

  var body: some View {
    SheetLink(.sharedProject(project)) {
      VStack(alignment: .leading) {
        Text(project.label)
          .font(.default(.headline))
        Text(project.ownerLabel)
          .foregroundColor(project.owner?.color)
      }
    }
  }

  init(_ project: Project.Shared) {
    self.project = project
  }
}

// MARK: - (PREVIEWS)

struct SharedProjectRow_Previews: PreviewProvider {
  static var previews: some View {
    SharedProjectRow(.example)
      .environmentObject(AppState.example)
  }
}
