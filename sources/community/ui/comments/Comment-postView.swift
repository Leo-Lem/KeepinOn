//	Created by Leopold Lemmermann on 07.11.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI
import AwardsController
import DatabaseService
import AuthenticationUI

extension Comment {
  struct PostView: View {
    let projectID: Project.ID

    var body: some View {
      if !accountController.isAuthenticated {
        Button("SIGN_IN_TO_COMMENT") { isAuthenticating = true }
          .frame(maxWidth: .infinity, minHeight: 44)
          .background(Color.blue)
          .foregroundColor(.white)
          .clipShape(Capsule())
          .contentShape(Capsule())
          .popover(isPresented: $isAuthenticating) { AuthenticationView(service: accountController.authService) }
      } else {
        VStack {
          TextField("ENTER_COMMENT_PROMPT", text: $text)
            .textFieldStyle(.roundedBorder)
            .textCase(nil)

          AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) { await postComment() } label: {
            Text("SEND")
              .frame(maxWidth: .infinity, minHeight: 44)
              .background(text.count < 2 ? Color.gray : .accentColor)
              .foregroundColor(.white)
              .clipShape(Capsule())
              .contentShape(Capsule())
          }
          .disabled(text.count < 2)
        }
        .disabled(!accountController.canPublish, message: "SIGN_INTO_ICLOUD")
        .alert(isPresented: Binding(item: $error), error: error) {}
      }
    }

    @State private var isAuthenticating = false
    @State private var text = ""
    @State private var error: DatabaseError?

    @EnvironmentObject private var communityController: CommunityController
    @EnvironmentObject private var accountController: AccountController
    @EnvironmentObject private var awardsController: AwardsController

    init(projectID: Project.ID) { self.projectID = projectID }
  }
}

private extension Comment.PostView {
  @MainActor func postComment() async {
    await printError {
      guard let user = accountController.user else { return }

      do {
        try await communityController.databaseService.insert(
          Comment(content: text.trimmingCharacters(in: .whitespacesAndNewlines), project: projectID, poster: user.id)
        )
        
        try await awardsController.postedComment()
      } catch let error as DatabaseError where error.hasDescription {
        self.error = error
      }

      self.text = ""
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
    
  }
}
#endif
