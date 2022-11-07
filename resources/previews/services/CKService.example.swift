//	Created by Leopold Lemmermann on 24.10.22.

import CloudKit

extension CKService {
  func createSampleData() async {
    let user = User.example
    var records: [CKRecord] = [user.mapToCKRecord()]

    for project in [Project.example, .example, .example] {
      let sharedProject = Project.Shared(project, owner: user)
      records.append(sharedProject.mapToCKRecord())

      records += project.items.map {
        var item = Item.Shared($0, owner: user)
        item.project = sharedProject
        return item
      }.map { $0.mapToCKRecord() }
      records
        .append(Comment(project: sharedProject, postedBy: user, content: "This is a comment").mapToCKRecord())
      records
        .append(Comment(project: sharedProject, postedBy: user, content: "This is another comment").mapToCKRecord())
      records
        .append(Comment(project: sharedProject, postedBy: user, content: "This is yet another comment").mapToCKRecord())
    }

    do {
      _ = try await publicDatabase.modifyRecords(saving: records, deleting: [])
      try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
    } catch {
      print(error.localizedDescription)
    }
    didChange.send()
  }

  func deleteAll() async {
    do {
      let queries: [CKQuery] = [
        CKQuery(recordType: Project.Shared.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: Item.Shared.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: Comment.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: User.ckIdentifier, predicate: .init(value: true)),
        CKQuery(recordType: Credential.ckIdentifier, predicate: .init(value: true))
      ]

      var ids = [CKRecord.ID]()

      for query in queries {
        ids += try await publicDatabase.records(matching: query).matchResults.map(\.0)
      }

      _ = try await publicDatabase.modifyRecords(saving: [], deleting: ids)

      didChange.send()
    } catch {
      print(error.localizedDescription)
    }
  }
}
