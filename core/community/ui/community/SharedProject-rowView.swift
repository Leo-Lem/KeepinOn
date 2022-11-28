//	Created by Leopold Lemmermann on 30.10.22.

import Errors
import RemoteDatabaseService
import SwiftUI

extension SharedProject {
  func rowView() -> some View { SharedProject.RowView(self) }

  struct RowView: View {
    let project: SharedProject

    var body: some View {
      Button(action: showDetails) {
        VStack(alignment: .leading) {
          Text(project.label)
            .font(.default(.headline))
          
          if let owner = owner {
            Text(owner.label)
              .foregroundColor(owner.color)
          }
        }
      }
      .task { await loadUser() }
      .accessibilityLabel("A11Y_SHAREDPROJECT")
      .accessibilityValue(project.a11y(owner?.label))
    }

    @EnvironmentObject private var mainState: MainState

    @State private var owner: User?

    init(_ project: SharedProject) { self.project = project }
  }
}

private extension SharedProject.RowView {
  func showDetails() {
    mainState.didChange.send(.sheet(.sharedProject(project)))
  }
  
  func loadUser() async {
    await printError {
      try await mainState.displayError {
        owner = try await mainState.remoteDBService.fetch(with: project.owner)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct SharedProjectRow_Previews: PreviewProvider {
    static var previews: some View {
      SharedProject.RowView(.example)
        .configureForPreviews()
    }
  }
#endif
