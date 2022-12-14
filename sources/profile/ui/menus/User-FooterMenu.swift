// Created by Leopold Lemmermann on 17.12.22.

import Errors
import LocalAuthentication
import LeosMisc
import SwiftUI
import ComposableArchitecture

extension User {
  struct FooterMenu: View {
    var body: some View {
      WithViewStore(store) { state in
        ViewState(user: state.account.user, hasNoiCloud: !state.account.canPublish)
      } content: { vm in
        Render(vm.user, hasNoiCloud: vm.hasNoiCloud)
      }
    }
    
    @EnvironmentObject private var store: StoreOf<MainReducer>
    
    struct ViewState: Equatable { var user: User?, hasNoiCloud: Bool }
    
    struct Render: View {
      let user: User?
      let hasNoiCloud: Bool
      
      var body: some View {
        HStack(alignment: .bottom) {
          User.PeekView(user)
          
          Spacer()
          
          VStack {
            Button { present(MainDetail.awards) } label: { Label("AWARDS_VIEW", systemImage: "person.bust") }
            
            Spacer()
            
            Button {
              Task(priority: .userInitiated) { await unlockAccountPage() }
            } label: { Label("CUSTOMIZE_PROFILE", systemImage: "slider.horizontal.3") }
          }
          .imageScale(.large)
          .labelStyle(.iconOnly)
          .tint(user?.color)
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .disabled(hasNoiCloud, message: "SIGN_INTO_ICLOUD")
      }
      
      @State private var previewingDetail = false
      @SceneStorage("editingIsUnlocked") private var editingIsUnlocked = false
      @Environment(\.present) private var present
      
      init(_ user: User?, hasNoiCloud: Bool) { (self.user, self.hasNoiCloud) = (user, hasNoiCloud) }
      
      @MainActor private func unlockAccountPage() async {
        await printError {
          if hasNoiCloud { return }
          guard let user else { return }
          
          if editingIsUnlocked { return present(MainDetail.customize(user)) }
          
          editingIsUnlocked = try await LAContext().evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: String(localized: "AUTHENTICATE_TO_EDIT_ACCOUNT")
          )
          
          if editingIsUnlocked { present(MainDetail.customize(user)) }
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct UserFooterView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      User.FooterMenu.Render(.example, hasNoiCloud: false)
      User.FooterMenu.Render(.example, hasNoiCloud: true).previewDisplayName("No iCloud")
      User.FooterMenu.Render(nil, hasNoiCloud: true).previewDisplayName("No iCloud and no user")
    }
    .presentPreview()
  }
}
#endif
