//	Created by Leopold Lemmermann on 24.10.22.

import CloudKit

extension PublicDatabaseService {
  func createSampleData() async {
    var convertibles = [any PublicModelConvertible]()

    // creating users
    for user in [User.example, .example, .example] {
      convertibles.append(user)

      // creating projects
      for project in [Project.example, .example, .example] {
        let sharedProject = Project.Shared(project, owner: user)
        convertibles.append(sharedProject)

        // creating items
        for itemID in project.items {
          let sharedItem = Item.Shared(
            id: itemID,
            project: project.id,
            title: Item.example.title,
            details: Item.example.details,
            isDone: Item.example.isDone
          )
          convertibles.append(sharedItem)
        }

        // creating comments

        for _ in 0..<Int.random(in: 3...10) {
          let comment = Comment(
            project: sharedProject,
            postedBy: user,
            content: Comment.example.content
          )
          convertibles.append(comment)
        }
      }
    }

    await printError {
      try await publish(convertibles)
      await sleep(for: .seconds(1))
      didChange.send()
    }
  }

  func deleteAll<T: PublicModelConvertible>(_ type: T.Type = T.self) async {
    await printError {
      try await unpublish(try await fetch(Query<T>(true)))
    }
  }

  func deleteAll() async {
    await deleteAll(Project.Shared.self)
    await deleteAll(Item.Shared.self)
    await deleteAll(Comment.self)
    await deleteAll(User.self)
    await deleteAll(Credential.self)

    didChange.send()
  }
}
