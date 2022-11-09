//	Created by Leopold Lemmermann on 25.10.22.

extension User: HasExample {
  static var example: User {
    User(id: "User\(Int.random(in: 1000...9999))", name: "Leo")
  }
}
