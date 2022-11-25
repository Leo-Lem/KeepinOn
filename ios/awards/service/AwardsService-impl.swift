//	Created by Leopold Lemmermann on 01.11.22.

import Combine
import Errors
import Foundation
import KeyValueStorageService
import UserDefaultsService

class AwardsServiceImplementation: AwardsService {
  let didChange = PassthroughSubject<AwardsChange, Never>()
  let allAwards: [Award]
  var unlockedAwards = Set<Award>() {
    didSet {
      unlockedAwards.subtracting(oldValue)
        .forEach { didChange.send(.unlocked($0)) }
    }
  }

  private let keyValueStorageService: KeyValueStorageService
  private var progress: Award.Progress

  init(_ keyValueStorageService: KeyValueStorageService = UserDefaultsService()) {
    self.keyValueStorageService = keyValueStorageService

    allAwards = Self.loadAllAwards()
    progress = printError {
      try keyValueStorageService.load(objectFor: Self.progressKey)
    } ?? Award.Progress()
    
    unlockAwards()
  }

  func notify(of progress: AwardsChange.Progress) async throws {
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
}

private extension AwardsServiceImplementation {
  func unlockAwards() {
    for award in allAwards where isUnlocked(award, progress: self.progress) {
      unlockedAwards.insert(award)
    }
  }
  
  func isUnlocked(_ award: Award, progress: Award.Progress) -> Bool {
    switch award.criterion {
    case .items:
      return progress.itemsAdded >= award.value
    case .complete:
      return progress.itemsCompleted >= award.value
    case .chat:
      return progress.commentsPosted >= award.value
    case .unlock:
      return progress.fullVersionIsUnlocked
    default:
      print("unknown award criterion: \(award.criterion)")
      return false
    }
  }
}

private extension AwardsServiceImplementation {
  static let progressKey = "award.progress"

  static func loadAllAwards() -> [Award] {
    do {
      if let url = Bundle.main.url(forResource: "Awards", withExtension: "json") {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Award].self, from: data)
      } else {
        fatalError("Failed to load awards from Bundle.")
      }
    } catch { fatalError("Failed to load awards from Bundle: \(error)") }
  }
}

#if DEBUG
  extension AwardsServiceImplementation {
    func resetProgress() { progress = .init() }
  }
#endif
