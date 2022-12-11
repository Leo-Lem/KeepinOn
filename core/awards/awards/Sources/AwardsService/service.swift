import Concurrency

public protocol AwardsService: EventDriver where Event == AwardsEvent {
  var allAwards: [Award] { get }
  var unlockedAwards: Set<Award> { get }

  func notify(of progress: Award.ProgressChange) async throws
  
  #if DEBUG
  func resetProgress()
  #endif
}
