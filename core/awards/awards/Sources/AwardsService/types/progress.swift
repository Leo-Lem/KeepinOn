//	Created by Leopold Lemmermann on 05.11.22.

public extension Award {
  struct Progress: Hashable, Codable {
    public var itemsAdded: Int
    public var itemsCompleted: Int
    public var commentsPosted: Int
    public var fullVersionIsUnlocked: Bool

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
  
  enum ProgressChange: Hashable {
    case addedItems(Int = 1)
    case completedItems(Int = 1)
    case postedComments(Int = 1)
    case becamePremium
  }
}
