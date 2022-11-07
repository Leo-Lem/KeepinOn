//	Created by Leopold Lemmermann on 24.10.22.

import SwiftUI

struct SharedProjectView: View {
  var body: some View {
    Text("Shared Project View")
  }

  @StateObject private var vm: ViewModel

  init(_ project: Project.Shared, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(project: project, appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct SharedProjectView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SharedProjectView(.example, appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview {
        SharedProjectView(.example, appState: .example)
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
