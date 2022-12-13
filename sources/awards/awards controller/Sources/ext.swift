//	Created by Leopold Lemmermann on 27.11.22.

public extension AwardsController {
  func addedItem() async throws { try await notify(of: .addedItems(1)) }
  func completedItem() async throws { try await notify(of: .completedItems(1)) }
  func postedComment() async throws { try await notify(of: .postedComments(1)) }
  func unlockedFullVersion() async throws { try await notify(of: .becamePremium) }
}
