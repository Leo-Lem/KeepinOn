//	Created by Leopold Lemmermann on 05.11.22.

extension Award {
  struct Progress: Hashable, Codable {
    var itemsAdded: Int,
        itemsCompleted: Int,
        commentsPosted: Int,
        fullVersionIsUnlocked: Bool

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
  }
}
