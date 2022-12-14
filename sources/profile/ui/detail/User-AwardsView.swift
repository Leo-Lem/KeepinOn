//	Created by Leopold Lemmermann on 29.11.22.

import LeosMisc
import SwiftUI
import ComposableArchitecture
import InAppPurchaseUI

extension User {
  struct AwardsView: View {
    var body: some View {
      Render(awards) { _ in fatalError("implement this") }
    }
    
    private let awards: [Award]
    
    init() {
      awards = Bundle.main.url(forResource: "Awards", withExtension: "json").flatMap { url in
        (try? Data(contentsOf: url)).flatMap { data in
          try? JSONDecoder().decode([Award].self, from: data)
        }
      } ?? []
    }
    
    struct Render: View {
      let awards: [Award]
      let isUnlocked: (Award) -> Bool
      
      var body: some View {
        ScrollView {
          LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
            ForEach(awards) { award in
              Button { displayedAward = award } label: {
                award
                  .icon(isUnlocked: isUnlocked(award))
                  .aspectRatio(1, contentMode: .fill)
              }
              .presentInfo(
                isUnlocked(award) ? "AWARD_UNLOCKED \(award.name)" : "AWARD_LOCKED \(award.name)",
                isPresented: Binding { displayedAward == award } set: { displayedAward = $0 ? award : nil }
              ) {
                purchaseButton(award)
              } message: { Text(award.description) }
            }
          }
        }
        .buttonStyle(.borderless)
        .popover(isPresented: $isPurchasing) {
          InAppPurchaseView(id: .fullVersion, service: iapService)
        }
        .navigationTitle("AWARDS_VIEW")
        #if os(iOS)
          .embedInNavigationStack()
        #endif
      }
      
      @State private var displayedAward: Award?
      @State private var isPurchasing = false
      @Dependency(\.inAppPurchaseService) private var iapService
      
      init(_ awards: [Award], isUnlocked: @escaping (Award) -> Bool) {
        (self.awards, self.isUnlocked) = (awards, isUnlocked)
      }
      
      @ViewBuilder private func purchaseButton(_ award: Award) -> some View {
        if award.criterion == .unlock, !isUnlocked(award) {
          Button { isPurchasing = true } label: { Label("UNLOCK_FULL_VERSION", systemImage: "cart") }
          Button("OK") {}
        }
      }
    }
  }
}

//func isAwardUnlocked(_ award: Award) -> Bool {
//  guard let progress = user?.progress else { return false }
//
//  switch award.criterion {
//  case .items:
//    return progress.itemsAdded >= award.value
//  case .complete:
//    return progress.itemsCompleted >= award.value
//  case .chat:
//    return progress.commentsPosted >= award.value
//  case .unlock:
//    return progress.fullVersionIsUnlocked
//  default:
//    debugPrint("unknown award criterion: \(award.criterion)")
//    return false
//  }
//}

// MARK: - (PREVIEWS)

#if DEBUG
  struct UserAwardsView_Previews: PreviewProvider {
    static var previews: some View {
      let unlock = Award(name: "Unlock", description: "", colorID: .gold, criterion: .unlock, value: 0, image: "smiley")
      User.AwardsView.Render([unlock, .example, .example, .example, .example]) { $0.criterion != .unlock }
        .presentPreview(inContext: true)
    }
  }
#endif
