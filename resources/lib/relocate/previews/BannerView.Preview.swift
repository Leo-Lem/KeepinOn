//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

extension BannerView {
  struct Preview: View {
    let dismissAfter: Duration?,
        link: () -> Void,
        content: () -> Content

    var body: some View {
      Binding.Preview(false) { binding in
        Button("Click me to display the banner!") { binding.wrappedValue = true }
          .banner(binding, dismissAfter: dismissAfter, link: link, content: content)
          .onAppear { binding.wrappedValue = true }
          .environment(\.dismiss) { binding.wrappedValue = false }
      }
    }

    init(
      dismissAfter: Duration? = nil,
      link: @escaping () -> Void = {},
      @ViewBuilder content: @escaping () -> Content
    ) {
      self.dismissAfter = dismissAfter
      self.link = link
      self.content = content
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct BannerViewPreview_Previews: PreviewProvider {
  static var previews: some View {
    BannerView.Preview {
      Text("Hello there")
        .padding()
    }
  }
}
#endif
