//	Created by Leopold Lemmermann on 05.11.22.

public extension Award {
  struct Progress: Hashable, Codable {
    public var itemsAdded: Int,
        itemsCompleted: Int,
        commentsPosted: Int,
        fullVersionIsUnlocked: Bool

    public init(
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
