//	Created by Leopold Lemmermann on 01.11.22.

import Foundation
import LeosMisc
import Concurrency

public class AwardsController: EventDriver, ObservableObject {
  public let eventPublisher = Publisher<Award>()
  
  public let allAwards: [Award]
  @Published public var unlockedAwards = Set<Award>() {
    didSet {
      if !isLoading {
        unlockedAwards.subtracting(oldValue)
          .forEach { eventPublisher.send($0) }
      }
    }
  }

  @Saved("award-progress") var progress = Award.Progress()

  private var isLoading = true

  public init() async {
    allAwards = Self.loadAllAwards()
    await unlockAwards()
    isLoading = false
  }

  public func notify(of progress: Award.ProgressChange) async throws {
    switch progress {
    case let .addedItems(count):
      self.progress.itemsAdded += count
    case let .completedItems(count):
      self.progress.itemsCompleted += count
    case let .postedComments(count):
      self.progress.commentsPosted += count
    case .becamePremium:
      self.progress.fullVersionIsUnlocked = true
    }

    await unlockAwards()
  }

  #if DEBUG
    public func resetProgress() {
      progress = .init()
      unlockedAwards = []
    }
  #endif
}
