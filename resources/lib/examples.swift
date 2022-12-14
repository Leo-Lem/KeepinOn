// Created by Leopold Lemmermann on 08.12.22.

import Previews

extension SharedProject: HasExample {
  static var example: SharedProject {
    SharedProject(
      .example,
      owner: User.example.id
    )
  }
}

extension SharedItem: HasExample {
  static var example: SharedItem {
    SharedItem(.example)
  }
}

extension Comment: HasExample {
  static var example: Comment {
    Comment(
      content: .random(in: 20 ..< 250, using: .letters.union(.whitespacesAndNewlines)).localizedCapitalized,
      project: SharedProject.example.id,
      poster: User.example.id
    )
  }
}

extension User: HasExample {
  static var example: User {
    User(
      id: .random(in: 4 ..< 15, using: .alphanumerics),
      name: .random(in: 4 ..< 20, using: .letters).localizedCapitalized
    )
  }
}

extension Award: HasExample {
  public static var example: Award {
    Award(
      name: .random(in: 5 ..< 15, using: .letters),
      description: .random(in: 10 ..< 30, using: .letters.union(.whitespacesAndNewlines)) + ".",
      colorID: .gold,
      criterion: Award.Criterion.allCases.randomElement()!,
      value: .random(in: 0..<50),
      image: User.AvatarID.allCases.randomElement()!.systemName
    )
  }
}

extension Friendship: HasExample {
  public static var example: Friendship { Friendship(User.example.id, User.example.id, accepted: .random()) }
}
