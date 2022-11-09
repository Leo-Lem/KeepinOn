//	Created by Leopold Lemmermann on 28.10.22.

enum AuthError: Error {
  case registration(RegError),
       login(LoginError),
       notAuthenticated,
       noConnection,
       noCloudKitPermissions

  enum RegError: Error {
    case invalidID(reason: InvalidIDReason),
         invalidPin(reason: InvalidPinReason)

    enum InvalidIDReason {
      case isTaken,
           unsupportedChars,
           tooShort
    }

    enum InvalidPinReason {
      case tooShort
    }
  }

  enum LoginError: Error {
    case unknownID(id: String),
         wrongPIN
  }
}
