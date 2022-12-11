//Created by Leopold Lemmermann on 08.12.22.

import AuthenticationUI
import SwiftUI

struct AuthenticationView: View {
  var body: some View {
    AuthenticationUI.AuthenticationView(service: mainState.authService)
  }
  
  @EnvironmentObject private var mainState: MainState
  
  init() {}
}
