//	Created by Leopold Lemmermann on 01.11.22.

import Combine
import Errors
import Foundation

final class KOAwardsService: AwardsService {
  let didChange = PassthroughSubject<AwardsChange, Never>()

  let allAwards: [Award]

  private var progress: Award.Progress? {
    didSet {
      let oldAwards = allAwards.filter { award in isUnlocked(award, progress: oldValue) }
      let newAwards = allAwards.filter(isUnlocked)

      let gainedAwards = newAwards.compactMap { award in
        !oldAwards.contains(award) ? award : nil
      }

      for award in gainedAwards {
        didChange.send(.unlocked(award))
      }
    }
  }

  private let authService: AuthService,
              keyValueService: KVSService
  init(
    authService: AuthService,
    keyValueService: KVSService
  ) {
    self.authService = authService
    self.keyValueService = keyValueService

    allAwards = Self.loadAllAwards()

    progress = loadProgress()
  }

  func isUnlocked(_ award: Award) -> Bool {
    isUnlocked(award, progress: progress)
  }

  func notify(of progress: AwardsChange.Progress) async throws {
    switch progress {
    case let .itemsAdded(count):
      self.progress?.itemsAdded += count
    case let .itemsCompleted(count):
      self.progress?.itemsCompleted += count
    case let .commentsPosted(count):
      self.progress?.commentsPosted += count
    case .unlockedFullVersion:
      self.progress?.fullVersionIsUnlocked = true
    }

    try await saveProgress()
    didChange.send(.progress(progress))
  }
}

private extension KOAwardsService {
  func isUnlocked(_ award: Award, progress: Award.Progress?) -> Bool {
    guard let progress = progress else { return false }

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

  static let progressKey = "award.progress"

  func loadProgress() -> Award.Progress {
    if case let .authenticated(user) = authService.status {
      return user.progress
    } else {
      var progress: Award.Progress?
      printError {
        progress = try keyValueService.fetchObject(for: Self.progressKey)
      }
      return progress ?? Award.Progress()
    }
  }

  func saveProgress() async throws {
    guard let progress = progress else { return }

    if case let .authenticated(user) = authService.status {
      var user = user
      user.progress = progress
      try await authService.update(user)
    }

    try keyValueService.store(object: progress, for: Self.progressKey)
  }

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
