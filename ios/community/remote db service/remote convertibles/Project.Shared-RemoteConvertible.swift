//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension Project.Shared: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Project"

  init(from remoteModel: RemoteModel) {
    let id = ID(uuidString: remoteModel.recordID.recordName) ?? ID()
    let items = remoteModel["items"] as? [CKRecord.Reference]
    let comments = remoteModel["comments"] as? [CKRecord.Reference]
    let owner = remoteModel["owner"] as? CKRecord.Reference

    self.init(
      id: id,
      title: remoteModel["title"] as? String ?? "",
      details: remoteModel["details"] as? String ?? "",
      isClosed: remoteModel["isClosed"] as? Bool ?? false,
      items: items?
        .map(\.recordID.recordName)
        .compactMap(Item.ID.init) ?? [],
      comments: comments?
        .map(\.recordID.recordName)
        .compactMap(Comment.ID.init) ?? [],
      owner: (owner?.recordID.recordName) ?? User.ID()
    )

    if items == nil { debugPrint("Faulty Items reference in Project with id \(id).") }
    if comments == nil { debugPrint("Faulty Comments reference in Project with id \(id).") }
    if owner == nil { debugPrint("Faulty Owner reference in Project with id \(id).") }
  }

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel.setValuesForKeys([
      "title": title,
      "details": details,
      "isClosed": isClosed,
      "items": items
        .map(\.description)
        .map(CKRecord.ID.init)
        .map { CKRecord.Reference(recordID: $0, action: .none) },
      "comments": comments
        .map(\.description)
        .map(CKRecord.ID.init)
        .map { CKRecord.Reference(recordID: $0, action: .none) },
      "owner": CKRecord.Reference(
        recordID: .init(recordName: owner),
        action: .deleteSelf
      )
    ])

    return remoteModel
  }
}

// fetching references

extension Project.Shared {
  func withOwner(_ owner: User) -> WithOwner { WithOwner(self, owner: owner) }

  func attachItems(_ service: RemoteDBService) async throws -> WithItems {
    WithItems(self, items: try await fetchItems(service).collect())
  }

  func attachComments(_ service: RemoteDBService) async throws -> WithComments {
    WithComments(self, comments: try await fetchComments(service).collect())
  }

  func attachOwner(_ service: RemoteDBService) async throws -> WithOwner? {
    try await fetchOwner(service).flatMap(withOwner)
  }
  
  func fetchItems(_ service: RemoteDBService) -> AsyncThrowingStream<Item.Shared, Error> {
    service.fetch(with: items)
  }
  
  func fetchComments(_ service: RemoteDBService) -> AsyncThrowingStream<Comment, Error> {
    service.fetch(with: comments)
  }
  
  func fetchOwner(_ service: RemoteDBService) async throws -> User? {
    try await service.fetch(with: owner)
  }
}
