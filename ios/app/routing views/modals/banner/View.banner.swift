//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension View {
  func banner<Content: View>(
    _ isPresented: Binding<Bool>,
    dismissAfter: Duration? = nil,
    link: @escaping () -> Void = {},
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    ZStack {
      self
      BannerView(
        isPresented: isPresented,
        dismissAfter: dismissAfter,
        link: link,
        content: content
      )
    }
  }

  func banner(
    _ title: Text,
    description: Text,
    isPresented: Binding<Bool>,
    dismissAfter: Duration? = nil,
    link: @escaping () -> Void = {}
  ) -> some View {
    banner(isPresented, dismissAfter: dismissAfter, link: link) {
      title.bold()
      description
        .multilineTextAlignment(.leading)
    }
  }

  func banner(
    _ title: LocalizedStringKey,
    description: LocalizedStringKey,
    isPresented: Binding<Bool>,
    dismissAfter: Duration? = nil,
    link: @escaping () -> Void = {}
  ) -> some View {
    banner(
      Text(title), description: Text(description), isPresented: isPresented, dismissAfter: dismissAfter, link: link
    )
  }

  @_disfavoredOverload
  func banner<S: StringProtocol>(
    _ title: S,
    description: S,
    isPresented: Binding<Bool>,
    dismissAfter: Duration? = nil,
    link: @escaping () -> Void = {}
  ) -> some View {
    banner(
      Text(title), description: Text(description), isPresented: isPresented, dismissAfter: dismissAfter, link: link
    )
  }
}
