//	Created by Leopold Lemmermann on 30.10.22.

struct Credential: Identifiable, Equatable {
  let id: String
  var pin: String?
}

extension Credential {
  init(userID: String, pin: String?) {
    id = Credential.getID(userID: userID)
    self.pin = pin
  }

  var userID: String {
    id.replacing(Credential.prefix, with: "")
  }
}

private extension Credential {
  static let prefix = "credential-"

  static func getID(userID: String) -> String {
    let cleanedID = clean(id: userID)
    return prefix.appending(cleanedID)
  }

  static func clean(id: String) -> String {
    id.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
