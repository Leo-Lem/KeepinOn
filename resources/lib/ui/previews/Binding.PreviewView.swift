//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

extension Binding {
  public struct PreviewView<Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    public var body: some View { content($value) }

    public init(
      _ initialValue: Value,
      @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
      self._value = State(initialValue: initialValue)
      self.content = content
    }
  }
}
