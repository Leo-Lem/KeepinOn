//	Created by Leopold Lemmermann on 31.10.22.

extension Credential: HasExample {
  static var example: Credential {
    Credential(
      userID: User.example.id,
      pin: .random(in: 4 ..< 10, using: .alphanumerics.union(.punctuationCharacters))
    )
  }
}
