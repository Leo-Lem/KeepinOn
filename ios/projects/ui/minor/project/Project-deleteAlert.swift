//	Created by Leopold Lemmermann on 23.11.22.

import SwiftUI

extension View {
  func deleteProjectAlert(
    isDeleting: Binding<Bool>,
    delete: @escaping () async -> Void
  ) -> some View {
    alert("DELETE_PROJECT_ALERT_TITLE", isPresented: isDeleting) {
      Button("GENERIC_DELETE", role: .destructive) {
        Task { await delete() }
      }
    } message: {
      Text("DELETE_PROJECT_ALERT_MESSAGE")
    }
  }
}
