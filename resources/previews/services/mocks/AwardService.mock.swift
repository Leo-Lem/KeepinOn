//	Created by Leopold Lemmermann on 05.11.22.

import Combine

final class MockAwardsService: AwardsService {
  var didChange = PassthroughSubject<AwardsChange, Never>()

  var allAwards = [Award]()

  func isUnlocked(_ award: Award) -> Bool {
    return .random()
  }

  func itemsAdded(_ number: Int) async throws {
    print("\(number) Items added!")
  }

  func itemsCompleted(_ number: Int) async throws {
    print("\(number) Items completed!")
  }

  func commentsPosted(_ number: Int) async throws {
    print("\(number) Comments posted!")
  }

  func unlockedFullVersion() async throws {
    print("Full version was unlocked!")
  }
}
