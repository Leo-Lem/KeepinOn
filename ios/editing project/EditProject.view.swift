//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

struct EditProjectView: View {
  var body: some View {
    Text("Edit Project View")
  }

  @StateObject private var vm: ViewModel

  init(_ project: Project, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(project, appState: appState))
  }
}

// MARK: - (Previews)

struct EditProjectView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      EditProjectView(.example, appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview {
        EditProjectView(.example, appState: .example)
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
