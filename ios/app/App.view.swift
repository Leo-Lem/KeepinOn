import SwiftUI

struct AppView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    Text("App view")
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(appState: .example)
      .previewDisplayName("Loading")
      .configureForPreviews()
  }
  }
