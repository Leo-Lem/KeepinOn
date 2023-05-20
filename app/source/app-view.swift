// Created by Leopold Lemmermann on 20.05.23.

import SwiftUI

struct AppView: View {
  var body: some View {
    Text("Hello, World!")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.background)
      .foregroundColor(.accentColor)
  }
}

// MARK: - (PREVIEWS)

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
