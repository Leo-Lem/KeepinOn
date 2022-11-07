//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct AwardsView: View {
  var body: some View {
    ScrollView {
      LazyVGrid(columns: cols) {
        ForEach(vm.allAwards) { award in
          AwardsView.AwardView(award: award, unlocked: vm.isUnlocked(award))
            .onTapGesture { vm.showAlert(for: award) }
        }
      }
    }
    .background(config.style.background)
    .styledNavigationTitle("AWARDS_TITLE")
  }

  @StateObject private var vm: ViewModel

  private let cols = [GridItem(.adaptive(minimum: 100, maximum: 100))]

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct AwardsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AwardsView(appState: .example)
        .previewDisplayName("Regular")

      NavigationStack { AwardsView(appState: .example) }
        .previewDisplayName("Navigation")
    }
    .configureForPreviews()
  }
}
