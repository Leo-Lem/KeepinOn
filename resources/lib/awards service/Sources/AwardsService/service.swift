import Combine

public protocol AwardsService {
  var didChange: PassthroughSubject<AwardsChange, Never> { get }
  
  var allAwards: [Award] { get }
  var unlockedAwards: Set<Award> { get }

  func notify(of progress: AwardsChange.Progress) async throws
}
