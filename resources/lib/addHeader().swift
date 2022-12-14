// Created by Leopold Lemmermann on 14.12.22.

import SwiftUI

public extension View {
  func addHeader<Header: View>(@ViewBuilder _ header: @escaping () -> Header) -> some View {
    modifier(ContentWithHeader(header))
  }
}

public struct ContentWithHeader<Header: View>: ViewModifier {
  let header: () -> Header

  public func body(content: Content) -> some View {
    VStack {
      HStack {
        header()
      }
      
      content
        .border(.top)
    }
    .padding(.top, 20)
    .padding(.bottom, -20)
  }

  public init(@ViewBuilder _ header: @escaping () -> Header) { self.header = header }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ContentWithHeaderPreviews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      Color.accentColor.frame(maxWidth: .infinity, minHeight: 300)
    }
    .addHeader { Text("My Header").bold() }
  }
}
#endif
