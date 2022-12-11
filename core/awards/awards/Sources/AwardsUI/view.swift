//	Created by Leopold Lemmermann on 07.10.22.

@_exported import AwardsService
import Concurrency
import InAppPurchaseService
import LeosMisc
@_exported import SwiftUI

@available(iOS 15, macOS 12, *)
public struct AwardsView: View {
  @Binding var isPurchasing: Bool
  let service: any AwardsService

  public var body: some View {
    ScrollView {
      LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 150)), count: 1)) {
        ForEach(allAwards) { award in
          let isUnlocked = isUnlocked(award)
          Button { displayedAward = award } label: {
            award
              .icon(isUnlocked: isUnlocked)
              .aspectRatio(1, contentMode: .fill)
          }
          .presentAwardDetails(
            award, isUnlocked: isUnlocked,
            isPresented: Binding { displayedAward == award } set: { newValue in
              displayedAward = newValue ? award : nil
            },
            isPurchasing: $isPurchasing
          )
        }
      }
    }
    .task { unlockedAwards = service.unlockedAwards }
    .onAppear {
      tasks["updateAwards"] = Task(priority: .background) { await updateAwards() }
    }
  }

  @State var displayedAward: Award?
  @State var unlockedAwards = Set<Award>()

  private let tasks = Tasks()

  public init(service: any AwardsService, isPurchasing: Binding<Bool>) {
    self.service = service
    _isPurchasing = isPurchasing
  }
}

@available(iOS 15, macOS 12, *)
extension AwardsView {
  var allAwards: [Award] { service.allAwards }
  func isUnlocked(_ award: Award) -> Bool { unlockedAwards.contains(award) }

  @MainActor func updateAwards() async {
    for await event in service.events {
      if case let .unlocked(award) = event { unlockedAwards.insert(award) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  @available(iOS 15, macOS 12, *)
  struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
      AwardsView(service: .implementation, isPurchasing: .constant(false))
    }
  }
#endif
