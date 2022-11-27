//	Created by Leopold Lemmermann on 27.11.22.

public extension AwardsService {
  func addedItem() async throws { try await notify(of: .itemsAdded(1)) }
  func completedItem() async throws { try await notify(of: .itemsCompleted(1)) }
  func postedComment() async throws { try await notify(of: .commentsPosted(1)) }
  func unlockedFullVersion() async throws { try await notify(of: .unlockedFullVersion) }
}