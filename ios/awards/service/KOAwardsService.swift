//	Created by Leopold Lemmermann on 01.11.22.

import Combine
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

  private let authenticationService: AuthenticationService,
              keyValueService: KeyValueService
  init(
    authenticationService: AuthenticationService,
    keyValueService: KeyValueService
  ) {
    self.authenticationService = authenticationService
    self.keyValueService = keyValueService

    allAwards = Self.loadAllAwards()

    progress = loadProgress()
  }

  func isUnlocked(_ award: Award) -> Bool {
    isUnlocked(award, progress: progress)
  }

  func itemsAdded(_ number: Int = 1) async throws {
    progress?.itemsAdded += number
    try await saveProgress()
    didChange.send(.progress(.itemsAdded(number)))
  }

  func itemsCompleted(_ number: Int = 1) async throws {
    progress?.itemsCompleted += number
    try await saveProgress()
    didChange.send(.progress(.itemsCompleted(number)))
  }

  func commentsPosted(_ number: Int = 1) async throws {
    progress?.commentsPosted += number
    try await saveProgress()
    didChange.send(.progress(.commentsPosted(number)))
  }

  func unlockedFullVersion() async throws {
    progress?.fullVersionIsUnlocked = true
    try await saveProgress()
    didChange.send(.progress(.unlockedFullVersion))
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

  func loadProgress() -> Award.Progress {
    if case let .authenticated(user) = authenticationService.status {
      return user.progress
    } else {
      var progress: Award.Progress?
      printError {
        progress = try keyValueService.fetchObject(for: "award.progress")
      }
      return progress ?? Award.Progress()
    }
  }

  func saveProgress() async throws {
    guard let progress = progress else { return }

    if case let .authenticated(user) = authenticationService.status {
      var user = user
      user.progress = progress
      try await authenticationService.update(user)
    }

    try keyValueService.insert(object: progress, for: "award.progress")
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
