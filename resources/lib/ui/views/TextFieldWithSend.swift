//	Created by Leopold Lemmermann on 25.10.22.

import SwiftUI

struct TextFieldWithSend: View {
  let prompt: LocalizedStringKey,
      sendLabel: LocalizedStringKey,
      minLength: Int,
      send: (String) -> Void

  var body: some View {
    VStack {
      TextField(prompt, text: $text)
        .textFieldStyle(.roundedBorder)
        .textCase(nil)

      Button {
        send(text)
        text = ""
      } label: {
        Text(sendLabel)
          .frame(maxWidth: .infinity, minHeight: 44)
          .background(sendIsDisabled ? Color.gray : Color.accentColor)
          .foregroundColor(.white)
          .clipShape(Capsule())
          .contentShape(Capsule())
      }
      .disabled(sendIsDisabled)
    }
  }
  
  init(
    initialText: String = "",
    prompt: LocalizedStringKey = "",
    sendLabel: LocalizedStringKey = "Send",
    minLength: Int = 0,
    send: @escaping (String) -> Void
  ) {
    self.text = initialText
    self.prompt = prompt
    self.sendLabel = sendLabel
    self.minLength = minLength
    self.send = send
  }

  private var sendIsDisabled: Bool {
    text.trimmingCharacters(in: .whitespacesAndNewlines).count < minLength
  }

  @State private var text: String
}

// MARK: - (PREVIEWS)

struct TextFieldWithSend_Previews: PreviewProvider {
    static var previews: some View {
      TextFieldWithSend {_ in}
    }
}
