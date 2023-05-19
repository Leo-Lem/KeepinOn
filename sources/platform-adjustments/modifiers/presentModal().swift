// Created by Leopold Lemmermann on 16.12.22.

import SwiftUI

extension View {
  @ViewBuilder func presentModal<T: Equatable & Identifiable, Content: View>(
    _ selected: Binding<T?>, presented: T, @ViewBuilder content: @escaping (T) -> Content
  ) -> some View {
    let binding = Binding { selected.wrappedValue == presented } set: { selected.wrappedValue = $0 ? presented : nil }

#if os(iOS)
    sheet(isPresented: binding) { content(presented) }
#elseif os(macOS)
    popover(isPresented: binding) { content(presented) }
#endif
  }
  
  @ViewBuilder func presentModal<Content: View>(
    _ isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content
  ) -> some View {
#if os(iOS)
    sheet(isPresented: isPresented, content: content)
#elseif os(macOS)
    popover(isPresented: isPresented, content: content)
#endif
  }
}
