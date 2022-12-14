//	Created by Leopold Lemmermann on 27.10.22.

import Colors
import ComposableArchitecture
import LeosMisc
import SwiftUI

extension User {
  struct CustomizationView: View {
    let user: User

    var body: some View {
      WithViewStore<_, ViewAction, _>(store, observe: \.account.canPublish) { action in
        switch action {
        case let .saveName(name):
          return .publicDatabase(.users(.modifyWith(id: user.id) { $0.name = name }))
        case let .saveColor(colorID):
          return .publicDatabase(.users(.modifyWith(id: user.id) { $0.colorID = colorID }))
        case let .saveAvatar(avatarID):
          return .publicDatabase(.users(.modifyWith(id: user.id) { $0.avatarID = avatarID }))
        }
      } content: { vm in
        Render(user: user, hasNoiCloud: !vm.state) {
          await vm.send(.saveName($0)).finish()
          // TODO: add error throwing
        } saveColorID: {
          await vm.send(.saveColor($0)).finish()
        } saveAvatarID: {
          await vm.send(.saveAvatar($0)).finish()
        }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>

    init(_ user: User) { self.user = user }

    enum ViewAction { case saveName(String), saveColor(ColorID), saveAvatar(AvatarID) }

    struct Render: View {
      let user: User
      let hasNoiCloud: Bool
      let saveName: (String) async throws -> Void
      let saveColorID: (ColorID) async -> Void
      let saveAvatarID: (AvatarID) async -> Void

      var body: some View {
        Form {
          Section("ACCOUNT_CHANGE_DISPLAYNAME") {
            ChangeNameMenu(user.name, save: saveName)
              .disabled(hasNoiCloud, message: "SIGN_INTO_ICLOUD")
          }

          Section("ACCOUNT_SELECT_COLOR") {
            ColorID.AsyncSelectionMenu(user.colorID, saveColorID: saveColorID)
              .disabled(hasNoiCloud, message: "SIGN_INTO_ICLOUD")
          }

          Section("ACCOUNT_SELECT_AVATAR") {
            User.AvatarID.SelectionMenu(user.avatarID, saveAvatarID: saveAvatarID)
              .disabled(hasNoiCloud, message: "SIGN_INTO_ICLOUD")
          }
        }
        .accessibilityLabel("A11Y_CUSTOMIZE_ACCOUNT")
        .scrollContentBackground(.hidden)
        .formStyle(.grouped)
        .animation(.default, value: user)
        #if os(iOS)
          .navigationTitle("CUSTOMIZE_PROFILE")
          .compactDismissButtonToolbar()
          .embedInNavigationStack()
        #endif
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct UserCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
      User.CustomizationView.Render(
        user: .example, hasNoiCloud: false
      ) { _ in } saveColorID: { _ in } saveAvatarID: { _ in }
        .presentPreview(inContext: true)

      User.CustomizationView.Render(
        user: .example, hasNoiCloud: true
      ) { _ in } saveColorID: { _ in } saveAvatarID: { _ in }
        .presentPreview(inContext: true)
        .previewDisplayName("No iCloud")
    }
  }
#endif
