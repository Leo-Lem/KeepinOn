//	Created by Leopold Lemmermann on 01.11.22.

import Combine

protocol AwardsService {
  var didChange: PassthroughSubject<AwardsChange, Never> { get }
  
  var allAwards: [Award] { get }

  func isUnlocked(_ award: Award) -> Bool

  func itemsAdded(_ number: Int) async throws
  func itemsCompleted(_ number: Int) async throws
  func commentsPosted(_ number: Int) async throws
  func unlockedFullVersion() async throws
}
