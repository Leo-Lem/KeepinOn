//	Created by Leopold Lemmermann on 23.11.22.

import AuthenticationService
import RemoteDatabaseService
import SwiftUI

enum Alert: Equatable {
  case remoteDBError(RemoteDatabaseError.Display),
       authError(AuthenticationError.Display)
}

extension View {
  @ViewBuilder func alert(_ errorAlert: Binding<Alert?>) -> some View {
    switch errorAlert.wrappedValue {
    case let .remoteDBError(display):
      alert(isPresented: Binding(optional: errorAlert), error: display) {}
    case let .authError(display):
      alert(isPresented: Binding(optional: errorAlert), error: display) {}
    default: self
    }
  }
}
