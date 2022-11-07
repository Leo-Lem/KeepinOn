//	Created by Leopold Lemmermann on 05.11.22.

import SwiftUI

extension View {
  func styledNavigationTitle(_ title: Text, style: UIFont.TextStyle = .largeTitle) -> some View {
    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: UIFont(name: config.style.fontName, size: UIFont.preferredFont(forTextStyle: style).pointSize)!
    ]

    return navigationTitle(title)
  }

  func styledNavigationTitle(_ title: LocalizedStringKey, style: UIFont.TextStyle = .largeTitle) -> some View {
    styledNavigationTitle(Text(title), style: style)
  }

  func styledNavigationTitle<S: StringProtocol>(raw title: S, style: UIFont.TextStyle = .largeTitle) -> some View {
    styledNavigationTitle(Text(title), style: style)
  }
}
