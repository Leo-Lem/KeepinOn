//	Created by Leopold Lemmermann on 07.11.22.

import Errors
import SwiftUI

struct PostCommentView: View {
  let canPostComments: Bool,
      post: (String) async throws -> Void,
      startAuthentication: () -> Void

  var body: some View {
    if canPostComments {
      VStack {
        TextField("ENTER_COMMENT_PROMPT", text: $text)
          .textFieldStyle(.roundedBorder)
          .textCase(nil)

        Button {
          Task(priority: .userInitiated) {
            await printError {
              try await post(text)
              text = ""
            }
          }
        } label: {
          Text("GENERIC_SEND")
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(sendIsDisabled ? Color.gray : Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .contentShape(Capsule())
        }
        .disabled(sendIsDisabled)
      }
    } else {
      Button("SIGN_IN_TO_COMMENT", action: startAuthentication)
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .contentShape(Capsule())
    }
  }

  @State private var text = ""

  private var sendIsDisabled: Bool {
    text.count < 2
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct PostCommentView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        PostCommentView(canPostComments: true) { _ in } startAuthentication: {}
          .previewDisplayName("Authenticated")

        PostCommentView(canPostComments: false) { _ in } startAuthentication: {}
          .previewDisplayName("Not authenticated")
      }
      .padding()
      .configureForPreviews()
    }
  }
#endif
