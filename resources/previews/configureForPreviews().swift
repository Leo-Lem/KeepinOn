//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension View {
  func configureForPreviews() -> some View {
    font(.default())
      .environmentObject(MainState.example)
  }
}
