//	Created by Leopold Lemmermann on 07.11.22.

import AuthenticationService
import Errors
import SwiftUI

extension Comment {
  struct PostView: View {
    let projectID: Project.ID

    var body: some View {
      if mainState.user != nil {
        VStack {
          TextField("ENTER_COMMENT_PROMPT", text: $text)
            .textFieldStyle(.roundedBorder)
            .textCase(nil)

          Button { postComment() } label: {
            Text("GENERIC_SEND")
              .frame(maxWidth: .infinity, minHeight: 44)
              .background(sendIsDisabled ? Color.gray : .accentColor)
              .foregroundColor(.white)
              .clipShape(Capsule())
              .contentShape(Capsule())
          }
          .disabled(sendIsDisabled)
        }
        .disabled(mainState.remoteDBService.status == .readOnly, message: "SIGN_INTO_ICLOUD")
      } else {
        Button("SIGN_IN_TO_COMMENT") { isAuthenticating = true }
          .frame(maxWidth: .infinity, minHeight: 44)
          .background(Color.blue)
          .foregroundColor(.white)
          .clipShape(Capsule())
          .contentShape(Capsule())
          .sheet(isPresented: $isAuthenticating) { AuthenticationView(service: mainState.authService) }
      }
    }

    @EnvironmentObject private var mainState: MainState
    @State private var isAuthenticating = false
    @State private var text = ""

    init(projectID: Project.ID) { self.projectID = projectID }
  }
}

private extension Comment.PostView {
  var sendIsDisabled: Bool { text.count < 2 }

  func postComment() {
    Task(priority: .userInitiated) {
      await printError {
        guard let user = mainState.user else { return }

        let text = self.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let comment = Comment(content: text, project: projectID, poster: user.id)

        await printError {
          try await mainState.displayError {
            try await mainState.remoteDBService.publish(comment)
            try await mainState.awardsService.postedComment()
          }
        }

        self.text = ""
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct CommentPostView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Comment.PostView(projectID: Project.ID())
      }
      .padding()
      .configureForPreviews()
    }
  }
#endif
