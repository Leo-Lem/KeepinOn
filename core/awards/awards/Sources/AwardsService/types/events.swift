//	Created by Leopold Lemmermann on 06.11.22.

public enum AwardsEvent: Equatable {
  case progress(Award.ProgressChange)
  case unlocked(Award)
}
