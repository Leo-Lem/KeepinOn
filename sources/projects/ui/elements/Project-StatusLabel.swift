// Created by Leopold Lemmermann on 08.12.22.

import SwiftUI

extension Project {
  func statusLabel() -> some View { StatusLabel(self.isClosed) }

  struct StatusLabel: View {
    let isClosed: Bool

    var body: some View {
      isClosed ?
        Label("CLOSED", systemImage: "checkmark.diamond") :
        Label("OPEN", systemImage: "diamond")
    }

    init(_ isClosed: Bool) { self.isClosed = isClosed }
  }
}

// MARK: - (PREVIEWS)

struct ProjectHeaderWithStatus_Previews: PreviewProvider {
  static var previews: some View {
    Project.StatusLabel(false)
      .previewDisplayName("Open")
    
    Project.StatusLabel(true)
      .previewDisplayName("Closed")
  }
}
