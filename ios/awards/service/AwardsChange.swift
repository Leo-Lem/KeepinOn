//	Created by Leopold Lemmermann on 06.11.22.

enum AwardsChange: Equatable {
  case progress(Progress),
       unlocked(Award)

  enum Progress: Equatable{
    case itemsAdded(Int),
         itemsCompleted(Int),
         commentsPosted(Int),
         unlockedFullVersion
  }
}
