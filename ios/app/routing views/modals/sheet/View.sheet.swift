//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension View {
  func sheet<Content: View>(
    _ isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    ZStack {
      self
      SheetView(isPresented: isPresented, content: content)
    }
  }
}
