//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct AccountView: View {
  var body: some View {
    Group {
      switch vm.authenticationStatus {
      case let .authenticated(user):
        EditAccountView(user: user) {
          vm.logout()
        } update: {
          try await vm.update($0)
        }
      case .notAuthenticated:
        AuthenticationView {
          try await vm.register(id: $0, pin: $1, name: $2)
        } login: {
          try await vm.login(id: $0, pin: $1)
        }
        .preferred(style: SheetViewStyle(size: .half, dismissButtonStyle: .bottom))
      }
    }
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AccountView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AccountView(appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview { AccountView(appState: .example) }
        .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
#endif
