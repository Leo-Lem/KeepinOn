//	Created by Leopold Lemmermann on 24.10.22.

import AuthenticationService
import Concurrency
import LeosMisc
import Previews
import SwiftUI

extension SharedProject {
  func detailView() -> some View { DetailView(self) }

  struct DetailView: View {
    let project: SharedProject

    var body: some View {
      NavigationStack {
        List {
          project.itemsSectionView()
          project.commentsSectionView()
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(project.label)
        #if os(iOS)
          .compactDismissButtonToolbar()
        #endif
      }
      .accessibilityLabel("SHARED_PROJECT_TITLE")
      .accessibilityValue(project.label)
    }

    init(_ project: SharedProject) { self.project = project }
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
      
    }
  }
#endif
