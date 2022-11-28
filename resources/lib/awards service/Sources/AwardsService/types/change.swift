//	Created by Leopold Lemmermann on 06.11.22.

public enum AwardsChange: Equatable {
  case progress(Progress),
       unlocked(Award)

  public enum Progress: Equatable{
    case itemsAdded(Int),
         itemsCompleted(Int),
         commentsPosted(Int),
         unlockedFullVersion
  }
}
