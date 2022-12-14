// Created by Leopold Lemmermann on 14.12.22.

import AuthenticationUI
import ComposableArchitecture
import DatabaseService
import Errors
import LeosMisc
import SwiftUI
  
extension User {
  struct FriendActionMenu: View {
    let friendID: User.ID
    
    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(
          friendship: state.account.friendship(for: friendID),
          currentUserID: state.account.id,
          hasNoiCloud: !state.account.canPublish
        )
      } send: { action in
        switch action {
        case .loadCurrentUserID: return .account(.loadID)
        case .loadFriendship: return .account(.loadFriendship(userID: friendID))
        case .addFriend: return .account(.addFriend(id: friendID))
        case .removeFriend: return .account(.removeFriend(id: friendID))
        }
      } content: { vm in
        Render(friendship: vm.friendship, currentUserID: vm.currentUserID, hasNoiCloud: vm.hasNoiCloud) {
          await vm.send(.addFriend).finish()
          // TODO: throw database error here
        } removeFriend: {
          await vm.send(.removeFriend).finish()
        }
        .task {
          await vm.send(.loadCurrentUserID).finish()
          await vm.send(.loadFriendship).finish()
        }
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
    init(_ friendID: User.ID) { self.friendID = friendID }
    
    struct ViewState: Equatable { var friendship: Friendship?, currentUserID: User.ID?, hasNoiCloud: Bool }
    enum ViewAction { case loadCurrentUserID, loadFriendship, addFriend, removeFriend }
    
    struct Render: View {
      let friendship: Friendship?
      let currentUserID: User.ID?
      let hasNoiCloud: Bool
      let addFriend: () async throws -> Void
      let removeFriend: () async throws -> Void
      
      var body: some View {
        Group {
          switch (friendship?.accepted, friendship?.sender) {
          case (false, currentUserID) where currentUserID != nil:
            button(add: false, label: Label("REVOKE_REQUEST", systemImage: "minus.circle"))
          case (false, _):
            button(add: true, label: Label("ACCEPT_REQUEST", systemImage: "checkmark.circle"))
            button(add: false, label: Label("DENY_REQUEST", systemImage: "xmark.circle"))
          case(true, _):
            button(add: false, label: Label("REMOVE_FRIEND", systemImage: "xmark.circle"))
          default:
            button(add: true, label: Label("ADD_FRIEND", systemImage: "plus.circle"))
          }
        }
        .alert(isPresented: Binding(item: $error), error: error) {}
        .alert("CANT_CONNECT_TO_ICLOUD_TITLE", isPresented: $isShowingiCloudAlert) {} message: {
          Text("CANT_CONNECT_TO_ICLOUD_MESSAGE")
        }
        .popover(isPresented: $isAuthenticating) { AuthenticationView(service: authService) }
      }
      
      @State private var isAuthenticating = false
      @State private var isShowingiCloudAlert = false
      @State private var error: DatabaseError?
      @Dependency(\.authenticationService) private var authService
            
      private func button<L: View>(add: Bool, label: L) -> some View {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          await printError {
            do {
              if currentUserID == nil {
                isAuthenticating = true
              } else if hasNoiCloud {
                isShowingiCloudAlert = true
              } else {
                if add { try await addFriend() } else { try await removeFriend() }
              }
            } catch let error as DatabaseError where error.hasDescription { self.error = error }
          }
        } label: { label }
        .buttonStyle(.borderless)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct AddFriendButton_Previews: PreviewProvider {
  static var previews: some View {
    let (sender, receiver) = (User.example.id, User.example.id)
    
    Form {
      Section {
        User.FriendActionMenu.Render(friendship: nil, currentUserID: sender, hasNoiCloud: false) {} removeFriend: {}
        User.FriendActionMenu.Render(
          friendship: Friendship(sender, receiver, accepted: false), currentUserID: receiver, hasNoiCloud: false
        ) {} removeFriend: {}
        User.FriendActionMenu.Render(
          friendship: Friendship(sender, receiver, accepted: false), currentUserID: sender, hasNoiCloud: false
        ) {} removeFriend: {}
        User.FriendActionMenu.Render(
          friendship: Friendship(sender, receiver, accepted: true), currentUserID: sender, hasNoiCloud: false
        ) {} removeFriend: {}
      }
      
      Section("Not logged in") {
        User.FriendActionMenu.Render(friendship: nil, currentUserID: nil, hasNoiCloud: false) {} removeFriend: {}
      }
      
      Section("No iCloud") {
        User.FriendActionMenu.Render(friendship: nil, currentUserID: sender, hasNoiCloud: true) {} removeFriend: {}
      }
    }
    .presentPreview()
  }
}
#endif
