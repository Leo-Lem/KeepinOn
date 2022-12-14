// Created by Leopold Lemmermann on 17.12.22.

import ComposableArchitecture
import Queries
import SwiftUI

extension User {
  struct FriendsView: View {
    let currentUserID: User.ID
    
    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        let friends = Array(
          [true, false]
            .compactMap { sent in
              try? state.publicDatabase.friendships.convertibles(
                matching: Query(
                  .init(sent ? \.sender : \.receiver, currentUserID), .init(\.accepted, true), compound: .and
                )
              )
              .map(sent ? \.receiver : \.sender)
            }
            .joined()
        )
        
        let sentRequests = state.publicDatabase.friendships.convertibles(
          matching: Query(.init(\.sender, currentUserID), .init(\.accepted, false), compound: .and)
        ).map(\.receiver)
        
        let receivedRequests = state.publicDatabase.friendships.convertibles(
          matching: Query(.init(\.receiver, currentUserID), .init(\.accepted, true), compound: .and)
        ).map(\.sender)
        
        return ViewState(friends: friends, receivedRequests: sentRequests, sentRequests: receivedRequests)
      } send: { action in
        switch action {
        case .loadCurrentUserID:
          return .account(.loadID)
        case .loadFriends:
          return .account(.loadFriends)
        case let .loadRequests(sent):
            return .publicDatabase(.friendships(.loadFor(
              query: Query(.init(sent ? \.sender : \.receiver, currentUserID), .init(\.accepted, false), compound: .and)
            )))
        }
      } content: { vm in
        Render(vm.friends, receivedRequests: vm.receivedRequests, sentRequests: vm.sentRequests)
          .task {
            await vm.send(.loadCurrentUserID).finish()
            vm.send(.loadFriends)
            vm.send(.loadRequests(sent: false))
            vm.send(.loadRequests(sent: true))
          }
      }
    }
    
    @Environment(\.present) private var present
    @EnvironmentObject private var store: StoreOf<MainReducer>
    
    struct ViewState: Equatable { var friends: [User.ID], receivedRequests: [User.ID], sentRequests: [User.ID] }
    enum ViewAction { case loadCurrentUserID, loadFriends, loadRequests(sent: Bool) }
    
    struct Render: View {
      let friends: [User.ID]
      let requests: (received: [User.ID], sent: [User.ID])
      
      var body: some View {
        List {
          Section("") {
            ForEach(friends, id: \.self) { friendID in
              Friendship.RowView(friendID: friendID)
            }
          }
            
          Section("NEW_FRIEND_REQUESTS") {
            ForEach(requests.received, id: \.self) { friendID in
              Friendship.RowView(friendID: friendID)
              // TODO: add option to accept instead of add button
            }
          }
            
          Section("SENT_FRIEND_REQUESTS") {
            ForEach(requests.sent, id: \.self) { friendID in
              Friendship.RowView(friendID: friendID)
            }
          }
        }
      }
      
      init(_ friends: [User.ID], receivedRequests: [User.ID], sentRequests: [User.ID]) {
        self.friends = friends
        self.requests = (receivedRequests, sentRequests)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserFriendsView_Previews: PreviewProvider {
  static var previews: some View {
    User.FriendsView.Render(
      [User.example.id], receivedRequests: [User.example.id], sentRequests: [User.example.id]
    )
    .presentPreview(inContext: true)
  }
}
#endif
