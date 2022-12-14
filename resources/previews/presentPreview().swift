// Created by Leopold Lemmermann on 17.12.22.

import Previews
import SwiftUI
import ComposableArchitecture

extension View {
  func presentPreview(inContext: Bool = false) -> some View { modifier(PreviewPresentor(inContext: inContext)) }
}

struct PreviewPresentor: ViewModifier {
  let inContext: Bool

  func body(content: Content) -> some View {
    Group {
      switch (inContext, size) {
//      case (true, .compact):
//        Binding.Preview(true) { binding in
//          Button("[Detail]") { binding.wrappedValue.toggle() }
//            .sheet(isPresented: binding) {
//              content
//            }
//        }
      case (true, .regular):
        Binding.Preview(true) { binding in
          NavigationSplitView {
            List { NavigationLink("[Detail]", value: binding.wrappedValue) }
              .listStyle(.sidebar)
          } detail: {
            if binding.wrappedValue { content } else { Text("EMPTY_TAB_PLACEHOLDER") }
          }
        }
      default:
        content
      }
    }
    .font(.default())
    .buttonStyle(.borderless)
#if os(macOS)
      .listStyle(.inset)
#endif
    .environment(\.size, size)
    .environmentObject(StoreOf<MainReducer>(initialState: .init(), reducer: MainReducer()))
  }

#if os(iOS)
  private var size: SizeClass { hSize == .compact ? .compact : .regular }
  @Environment(\.horizontalSizeClass) private var hSize
#elseif os(macOS)
  private let size = SizeClass.regular
#endif

  init(inContext: Bool = false) { self.inContext = inContext }
}
