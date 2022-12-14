//	Created by Leopold Lemmermann on 05.11.22.

extension Award {
  struct Progress: Hashable, Codable {
    var itemsAdded: Int
    var itemsCompleted: Int
    var commentsPosted: Int
    var fullVersionIsUnlocked: Bool

    init(
      itemsAdded: Int = 0,
      itemsCompleted: Int = 0,
      commentsPosted: Int = 0,
      fullVersionIsUnlocked: Bool = false
    ) {
      self.itemsAdded = itemsAdded
      self.itemsCompleted = itemsCompleted
      self.commentsPosted = commentsPosted
      self.fullVersionIsUnlocked = fullVersionIsUnlocked
    }

    mutating func addedItem(_ count: Int = 1) { itemsAdded += count }
    mutating func completedItem(_ count: Int = 1) { itemsCompleted += count }
    mutating func postedComment(_ count: Int = 1) { commentsPosted += count }
    mutating func unlockedFullVersion() { fullVersionIsUnlocked = true }

    #if DEBUG
    mutating func resetProgress() {
      (itemsAdded, itemsCompleted, commentsPosted) = (0, 0, 0)
      fullVersionIsUnlocked = false
    }
    #endif
  }
}
