//	Created by Leopold Lemmermann on 24.10.22.

import CloudKit

typealias PublicUserError = PublicDatabaseError.UserRelevancyReason

extension PublicDatabaseError {
  init(ckError: CKError) {
    switch ckError.code {
    case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
      self = .userRelevant(reason: .noNetwork)
    case .notAuthenticated:
      self = .userRelevant(reason: .notAuthenticated)
    case .requestRateLimited:
      self = .userRelevant(reason: .rateLimited)
    default:
      self = .other(ckError)
    }
  }
}
