//	Created by Leopold Lemmermann on 10.10.22.

import Errors
import LeosMisc
import Previews
import SwiftUI

extension User.AvatarID {
  struct SelectionMenu: View {
    let avatarID: User.AvatarID
    let save: (User.AvatarID) async -> Void
    
    var body: some View {
      VStack {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHGrid(rows: Array(repeating: GridItem(.fixed(50)), count: 3)) {
            ForEach(User.AvatarID.allCases, id: \.self, content: selectAvatarButton)
          }
        }
        .border(.leading, .trailing)
        
        HStack {
          TextField("OTHER_SFSYMBOL_PROMPT", text: $symbolName)
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
#if os(iOS)
            .textInputAutocapitalization(.never)
#endif
          
          if symbolExists { selectAvatarButton(.other(symbolName)).padding(3) }
        }
        .animation(.default, value: symbolExists)
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("ACCOUNT_SELECT_AVATAR")
      .accessibilityValue(self.avatarID.systemName)
    }
    
    @State private var symbolName = ""
    
    @Environment(\.dismiss) private var dismiss
    
    private var symbolExists: Bool { User.AvatarID.checkSymbolExists(symbolName) }
    private var otherSymbolIsSelected: Bool {
      if self.avatarID == .other(symbolName) { return true } else { return false }
    }
    
    init(_ avatarID: User.AvatarID, saveAvatarID: @escaping (User.AvatarID) async -> Void) {
      (self.avatarID, self.save) = (avatarID, saveAvatarID)
    }
    
    func selectAvatarButton(_ avatarID: User.AvatarID) -> some View {
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await save(avatarID) } label: {
        avatarID.icon()
          .foregroundColor(avatarID == self.avatarID ? .accentColor : .primary)
          .frame(width: 50, height: 50)
      }
      .buttonStyle(.borderless)
      .if(avatarID == self.avatarID) { $0.accessibilityAddTraits(.isSelected) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
enum AvatarIDSelectionMenuPreviews: PreviewProvider {
  static var previews: some View {
    User.AvatarID.SelectionMenu(.smiley) { _ in }.presentPreview()
  }
}
#endif
