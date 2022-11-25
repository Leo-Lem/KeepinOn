//	Created by Leopold Lemmermann on 22.11.22.

import SwiftUI

public extension View {
  @_disfavoredOverload
  func title<S: StringProtocol>(_ title: S) -> some View { self.title(Text(title)) }
  func title(_ title: LocalizedStringKey) -> some View { self.title(Text(title)) }
  func title(_ title: Text) -> some View {
    VStack(alignment: .leading) {
      title
        .bold()
        .font(.default(.largeTitle))
        .padding(.leading)
        .padding(.top)

      self
    }
  }
}
