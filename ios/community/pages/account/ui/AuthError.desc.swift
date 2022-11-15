//	Created by Leopold Lemmermann on 05.11.22.

import Foundation

extension AuthError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .registration(registrationError):
      return String(
        format: NSLocalizedString("AUTH_ERROR_REG %@", comment: ""),
        registrationError.localizedDescription
      )
    case let .login(loginError):
      return String(
        format: NSLocalizedString("AUTH_ERROR_LOGIN %@", comment: ""),
        loginError.localizedDescription
      )
    case .notAuthenticated:
      return String(localized: .init("AUTH_ERROR_NOTAUTH"))
    case .noConnection:
      return String(localized: .init("AUTH_ERROR_NOCLOUDKIT"))
    case .noCloudKitPermissions:
      return String(localized: .init("AUTH_ERROR_NOCLOUDKIT"))
    }
  }
}

extension AuthError.RegError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .invalidID(reason):
      return String(
        format: NSLocalizedString("AUTH_ERROR_REG_USERID %@", comment: ""),
        {
          switch reason {
          case .isTaken:
            return String(localized: .init("AUTH_ERROR_REG_USERID_ISTAKEN"))
          case .tooShort:
            return String(localized: .init("AUTH_ERROR_REG_USERID_TOOSHORT"))
          case .unsupportedChars:
            return String(localized: .init("AUTH_ERROR_REG_USERID_UNSUPPORTEDCHARS"))
          }
        }()
      )
    case let .invalidPin(reason):
      return String(
        format: NSLocalizedString("AUTH_ERROR_REG_PIN %@", comment: ""),
        {
          switch reason {
          case .tooShort:
            return String(localized: .init("AUTH_ERROR_REG_PIN_TOOSHORT"))
          }
        }()
      )
    }
  }
}

extension AuthError.RegError.InvalidIDReason {}

extension AuthError.LoginError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .unknownID(id):
      return String(format: NSLocalizedString("AUTH_ERROR_LOGIN_USERID %@", comment: ""), id)
    case .wrongPIN:
      return String(localized: .init("AUTH_ERROR_LOGIN_PIN"))
    }
  }
}
