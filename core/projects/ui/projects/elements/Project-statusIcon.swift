// Created by Leopold Lemmermann on 08.12.22.

import SwiftUI

extension Project {
  func statusIcon() -> some View { StatusIcon(self) }

  struct StatusIcon: View {
    let project: Project

    var body: some View {
      project.isClosed ?
        Label("CLOSED", systemImage: "checkmark.diamond") :
        Label("OPEN", systemImage: "diamond")
    }

    init(_ project: Project) { self.project = project }
  }
}

// MARK: - (PREVIEWS)

struct ProjectHeaderWithStatus_Previews: PreviewProvider {
  static var previews: some View {
    Project.example.statusIcon()
  }
}
