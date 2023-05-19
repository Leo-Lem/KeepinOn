// Created by Leopold Lemmermann on 17.12.22.

import AuthenticationUI
import ComposableArchitecture
import LeosMisc
import MyAuthenticationService
import Queries
import SwiftUI

struct ProfileView: View {
  var body: some View {
    WithPresentationViewStore { _, detail in
      WithAccountViewStore { currentUserID, _ in
        Render(currentUserID: currentUserID, detail: detail)
      }
    }
  }
  
  @EnvironmentObject private var store: StoreOf<MainReducer>
  
  enum ViewAction { case load }
  
  struct Render: View {
    let currentUserID: User.ID?
    @Binding var detail: MainDetail
    
    var body: some View {
      if let currentUserID {
        VStack {
          List {
            Button { detail = .friends(id: currentUserID) } label: {
              Label("FRIENDS_VIEW", systemImage: "person.3")
            }
            
            Button { detail = .projects(id: currentUserID) } label: {
              Label("YOUR_SHAREDPROJECTS_VIEW", systemImage: "square.and.arrow.up.on.square")
            }
            
            Button { detail = .comments(id: currentUserID) } label: {
              Label("YOUR_COMMENTS_VIEW", systemImage: "text.bubble")
            }
          }
          .listStyle(.sidebar)
          .scrollContentBackground(.hidden)
          
          User.FooterMenu()
            .border(.top)
        }
      } else {
        Button("PLEASE_SIGN_IN") { isAuthenticating = true }
          .onAppear { isAuthenticating = true }
          .popover(isPresented: $isAuthenticating) { AuthenticationView(service: authService) }
      }
    }
    
    @State private var isAuthenticating = false
    @Dependency(\.authenticationService) private var authService
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ProfileView.Render(currentUserID: User.example.id, detail: .constant(.empty))
      ProfileView.Render(currentUserID: nil, detail: .constant(.empty))
        .previewDisplayName("Not logged in")
    }
    .presentPreview()
  }
}
#endif
