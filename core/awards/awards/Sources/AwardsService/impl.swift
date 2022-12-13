//	Created by Leopold Lemmermann on 01.11.22.

import LeosMisc

public extension AwardsService where Self == AwardsServiceImpl {
  static var implementation: Self { AwardsServiceImpl() }
}

open class AwardsServiceImpl: AwardsService {
  public let eventPublisher = Publisher<AwardsEvent>()
  public let allAwards: [Award]
  public var unlockedAwards = Set<Award>() {
    didSet {
      if !isLoading {
        unlockedAwards.subtracting(oldValue)
          .forEach { eventPublisher.send(.unlocked($0)) }
      }
    }
  }

  @Saved("award-progress") var progress = Award.Progress()

  private var isLoading = true

  public init() {
    allAwards = Self.loadAllAwards()
    unlockAwards()
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

    unlockAwards()
    eventPublisher.send(.progress(progress))
  }

  #if DEBUG
    public func resetProgress() {
      progress = .init()
      unlockedAwards = []
    }
  #endif
}
