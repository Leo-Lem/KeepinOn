// Created by Leopold Lemmermann on 14.12.22.

import SwiftUI

public extension View {
  func border(_ edges: Edge...) -> some View {
    VStack {
      if edges.contains(.top) { Divider().offset(y: 7) }
      HStack {
        if edges.contains(.leading) { Divider().offset(x: 7) }
        self
        if edges.contains(.trailing) { Divider().offset(x: -7) }
      }
      if edges.contains(.bottom) { Divider().offset(y: -7) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct BorderPreviews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      Color.accentColor.frame(maxWidth: .infinity, minHeight: 300)
    }
    .border(.top)
  }
}
#endif
