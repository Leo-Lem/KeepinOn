//	Created by Leopold Lemmermann on 05.11.22.

import Combine

final class MockAwardsService: AwardsService {
  var didChange = PassthroughSubject<AwardsChange, Never>()

  var allAwards = [Award]()

  func isUnlocked(_ award: Award) -> Bool {
    return .random()
  }

  func notify(of progress: AwardsChange.Progress) async throws {
    print("Progress received: \(progress)")
  }
}
