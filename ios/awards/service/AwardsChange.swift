//	Created by Leopold Lemmermann on 06.11.22.

enum AwardsChange {
  case progress(Progress),
       unlocked(Award)

  enum Progress {
    case itemsAdded(Int),
         itemsCompleted(Int),
         commentsPosted(Int),
         unlockedFullVersion
  }
}
