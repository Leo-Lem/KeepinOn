//	Created by Leopold Lemmermann on 07.10.22.

import Concurrency
import InAppPurchaseService
import LeosMisc
import SwiftUI

struct AwardsView: View {
  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 100))]) {
        ForEach(allAwards) { award in
          award.icon(isUnlocked: isUnlocked(award))
            .frame(width: 100, height: 100)
            .onTapGesture { displayedAward = award }
          #if os(iOS)
            .alert(
              "\(displayedAward?.name ?? "???") (\(Text(isUnlocked(award) ? "UNLOCKED" : "LOCKED")))",
              isPresented: Binding(optional: $displayedAward),
              presenting: displayedAward
            ) { award in
              if award.criterion == .unlock && !isUnlocked(award) {
                Button { isPurchasing = true } label: {
                  Label("UNLOCK_FULL_VERSION", systemImage: "cart")
                }

                Button("GENERIC_OK") {}
              }
            } message: { award in
              Text("\(award.description)")
            }
          #endif
        }
      }
      #if os(macOS)
      .popover(item: $displayedAward) { award in
        let isUnlocked = isUnlocked(award)

        HStack {
          VStack {
            Text(isUnlocked ? "UNLOCKED \(award.name)" : "LOCKED").bold()
            Text(award.description)
          }
        }

        HStack {
          if award.criterion == .unlock && !isUnlocked {
            Button { isPurchasing = true } label: {
              Label("UNLOCK_FULL_VERSION", systemImage: "cart")
            }
          }
        }
      }
      #endif
    }
    .background(Config.style.background)
    .sheet(isPresented: $isPurchasing) {
      PurchaseID.fullVersion.view(service: mainState.purchaseService)
    }
    .toolbar(.visible, for: .navigationBar)
    .task {
      unlockedAwards = service.unlockedAwards

      tasks.add(service.didChange.getTask(.high) { change in
        if case let .unlocked(award) = change { unlockedAwards.insert(award) }
      })
    }
  }

  @EnvironmentObject private var mainState: MainState
  @State private var displayedAward: Award?
  @State private var isPurchasing = false
  @State private var unlockedAwards = Set<Award>()

  private let tasks = Tasks()
}

private extension AwardsView {
  var service: AwardsService { mainState.awardsService }
  var allAwards: [Award] { service.allAwards }

  func isUnlocked(_ award: Award) -> Bool { unlockedAwards.contains(award) }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        AwardsView()
          .previewDisplayName("Regular")

        NavigationStack(root: AwardsView.init)
          .previewDisplayName("Navigation")
      }
      .configureForPreviews()
    }
  }
#endif
