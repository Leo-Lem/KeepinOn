//	Created by Leopold Lemmermann on 24.10.22.

import CloudKit
import Errors
import Concurrency

extension RemoteDBService {
  func createSampleData() async {
    var convertibles = [any RemoteConvertible]()

    // creating users
    for user in [User.example, .example, .example] {
      convertibles.append(user)

      // creating projects
      for project in [Project.example, .example, .example] {
        let sharedProject = Project.Shared(project, owner: user.id)
        convertibles.append(sharedProject)

        // creating items
        for itemID in project.items {
          let sharedItem = Item.Shared(
            id: itemID,
            title: Item.example.title,
            details: Item.example.details,
            isDone: Item.example.isDone,
            project: project.id
          )
          convertibles.append(sharedItem)
        }

        // creating comments

        for _ in 0 ..< Int.random(in: 3 ... 10) {
          convertibles.append(Comment(
            content: Comment.example.content,
            project: sharedProject.id,
            poster: user.id
          ))
        }
      }
    }

    await printError {
      try await publish(convertibles)
      await sleep(for: 1)
    }
  }

  func unpublishAll() async {
    await printError {
      try await unpublishAll(Project.Shared.self)
      try await unpublishAll(Item.Shared.self)
      try await unpublishAll(Comment.self)
      try await unpublishAll(User.self)
      try await unpublishAll(Credential.self)
    }
  }
}
