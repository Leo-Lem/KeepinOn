// Created by Leopold Lemmermann on 14.12.22.

import LeosMisc
import SwiftUI

public extension TextField where Label == Text {
  struct WithConfirm: View {
    @Binding var text: String
    let prompt: Text
    let confirmIsDisabled: Bool
    let confirm: () async -> Void
    
    public var body: some View {
      HStack {
        TextField(text: $text) { prompt }
          .onSubmit { Task(priority: .userInitiated) {
            if !confirmIsDisabled { await confirm() }
          }}
        
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await confirm() } label: {
          SwiftUI.Label("CONFIRM", systemImage: "paperplane.circle").labelStyle(.iconOnly)
        }
        .disabled(confirmIsDisabled)
#if os(iOS)
          .buttonStyle(.borderedProminent)
#elseif os(macOS)
          .buttonStyle(.bordered)
#endif
      }
    }
    
    public init(
      _ title: Text, text: Binding<String>,
      confirmIsDisabled: Bool = false, confirm: @escaping () async -> Void
    ) {
      (self.prompt, _text) = (title, text)
      (self.confirmIsDisabled, self.confirm) = (confirmIsDisabled, confirm)
    }
    
    @_disfavoredOverload
    public init<S: StringProtocol>(
      _ title: S, text: Binding<String>,
      confirmIsDisabled: Bool = false, confirm: @escaping () async -> Void
    ) {
      (self.prompt, _text) = (Text(title), text)
      (self.confirmIsDisabled, self.confirm) = (confirmIsDisabled, confirm)
    }
    
    public init(
      _ titleKey: LocalizedStringKey, text: Binding<String>,
      confirmIsDisabled: Bool = false, confirm: @escaping () async -> Void
    ) {
      (self.prompt, _text) = (Text(titleKey), text)
      (self.confirmIsDisabled, self.confirm) = (confirmIsDisabled, confirm)
    }
  }
}
