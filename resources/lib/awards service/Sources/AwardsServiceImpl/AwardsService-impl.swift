//	Created by Leopold Lemmermann on 01.11.22.

import AwardsService
import Combine
import Errors
import Foundation
import KeyValueStorageService
import UserDefaultsService

open class AwardsServiceImpl: AwardsService {
  public let didChange = PassthroughSubject<AwardsChange, Never>()
  public let allAwards: [Award]
  public var unlockedAwards = Set<Award>() {
    didSet {
      unlockedAwards.subtracting(oldValue)
        .forEach { didChange.send(.unlocked($0)) }
    }
  }

  let keyValueStorageService: KeyValueStorageService
  static let progressKey = "award.progress"
  var progress: Award.Progress

  public init(_ keyValueStorageService: KeyValueStorageService = UserDefaultsService()) {
    self.keyValueStorageService = keyValueStorageService

    allAwards = Self.loadAllAwards()
    progress = printError {
      try keyValueStorageService.load(objectFor: Self.progressKey)
    } ?? Award.Progress()

    unlockAwards()
  }

  public func notify(of progress: AwardsChange.Progress) async throws {
    switch progress {
    case let .itemsAdded(count):
      self.progress.itemsAdded += count
    case let .itemsCompleted(count):
      self.progress.itemsCompleted += count
    case let .commentsPosted(count):
      self.progress.commentsPosted += count
    case .unlockedFullVersion:
      self.progress.fullVersionIsUnlocked = true
    }

    unlockAwards()

    try keyValueStorageService.store(object: self.progress, for: Self.progressKey)
    didChange.send(.progress(progress))
  }

  #if DEBUG
    public func resetProgress() { progress = .init() }
  #endif
}
