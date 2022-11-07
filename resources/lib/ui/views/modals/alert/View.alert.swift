//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension View {
  func alert<Content: View, Actions: View>(
    _ isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content,
    @ViewBuilder actions: @escaping (_ dismiss: @escaping () -> Void) -> Actions
  ) -> some View {
    ZStack {
      self
      AlertView(
        isPresented: isPresented,
        content: content(),
        actions: actions
      )
    }
  }

  func alert<Actions: View>(
    _ title: Text,
    description: Text,
    isPresented: Binding<Bool>,
    actions: @escaping (_ dismiss: @escaping () -> Void) -> Actions
  ) -> some View {
    alert(isPresented, content: {
      title.bold()
      description
    }, actions: actions)
  }

  func alert<Actions: View>(
    _ title: LocalizedStringKey,
    description: LocalizedStringKey,
    isPresented: Binding<Bool>,
    actions: @escaping (_ dismiss: @escaping () -> Void) -> Actions
  ) -> some View {
    alert(Text(title), description: Text(description), isPresented: isPresented, actions: actions)
  }

  @_disfavoredOverload
  func alert<S: StringProtocol, Actions: View>(
    _ title: S,
    description: S,
    isPresented: Binding<Bool>,
    actions: @escaping (_ dismiss: @escaping () -> Void) -> Actions
  ) -> some View {
    alert(Text(title), description: Text(description), isPresented: isPresented, actions: actions)
  }
}
