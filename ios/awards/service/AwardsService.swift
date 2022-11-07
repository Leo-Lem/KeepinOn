//	Created by Leopold Lemmermann on 01.11.22.

import Combine

protocol AwardsService {
  var didChange: PassthroughSubject<AwardsChange, Never> { get }
  
  var allAwards: [Award] { get }

  func isUnlocked(_ award: Award) -> Bool

  func notify(of progress: AwardsChange.Progress) async throws
}

// MARK: - (CONVENIENCE)

extension AwardsService {
  func addedItem() async throws { try await notify(of: .itemsAdded(1)) }
  func completedItem() async throws { try await notify(of: .itemsCompleted(1)) }
  func postedComment() async throws { try await notify(of: .commentsPosted(1)) }
  func unlockedFullVersion() async throws { try await notify(of: .unlockedFullVersion) }
}
