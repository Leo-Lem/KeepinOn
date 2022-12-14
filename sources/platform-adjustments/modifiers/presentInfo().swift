//	Created by Leopold Lemmermann on 28.11.22.

import SwiftUI

extension View {
  @ViewBuilder func presentInfo<A: View, M: View>(
    _ titleKey: LocalizedStringKey, isPresented: Binding<Bool>,
    @ViewBuilder actions: @escaping () -> A, message: @escaping () -> M
  ) -> some View {
    presentInfo(Text(titleKey), isPresented: isPresented, actions: actions, message: message)
  }

  @_disfavoredOverload
  @ViewBuilder func presentInfo<A: View, M: View, S: StringProtocol>(
    _ title: S, isPresented: Binding<Bool>, @ViewBuilder actions: @escaping () -> A, message: @escaping () -> M
  ) -> some View {
    presentInfo(Text(title), isPresented: isPresented, actions: actions, message: message)
  }

  @_disfavoredOverload
  @ViewBuilder func presentInfo<A: View, M: View>(
    _ title: Text, isPresented: Binding<Bool>, @ViewBuilder actions: @escaping () -> A, message: @escaping () -> M
  ) -> some View {
    modifier(InfoPresentor(isPresented: isPresented, title: title, actions: actions, message: message))
  }
}

struct InfoPresentor<A: View, M: View>: ViewModifier {
  @Binding var isPresented: Bool
  let title: Text
  let actions: () -> A, message: () -> M
  
  func body(content: Content) -> some View {
    if size == .compact {
      content
        .alert(title, isPresented: $isPresented, actions: actions, message: message)
    } else {
      content
        .popover(isPresented: $isPresented) {
          VStack {
            title.bold()
            message()
            HStack(content: actions)
          }
          .padding()
        }
    }
  }
  
  @Environment(\.size) private var size
}
