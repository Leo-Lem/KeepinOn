//	Created by Leopold Lemmermann on 27.10.22.

import SwiftUI

extension CKServiceError.UserRelevantError: LocalizedError {
  public var errorDescription: String? {
    let string: String

    switch self {
    case .noNetwork:
      string = "CKERROR_CONNECTION"
    case .notAuthenticated:
      string = "CKERROR_AUTH"
    case .rateLimited:
      string = "CKERROR_RATE"
    }
    
    return String(localized: .init(string))
  }
}
