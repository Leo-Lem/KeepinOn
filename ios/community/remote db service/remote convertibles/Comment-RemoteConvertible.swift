//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension Comment: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Comment"

  init(from remoteModel: RemoteModel) {
    let id = UUID(uuidString: remoteModel.recordID.recordName) ?? UUID()
    let project = remoteModel["project"] as? CKRecord.Reference
    let poster = remoteModel["poster"] as? CKRecord.Reference
    
    self.init(
      id: id,
      timestamp: remoteModel["timestamp"] as? Date ?? .now,
      content: remoteModel["content"] as? String ?? "",
      project: (project?.recordID.recordName)
        .flatMap(Project.Shared.ID.init) ?? Project.Shared.ID(),
      poster: (poster?.recordID.recordName) ?? User.ID()
    )
    
    if project == nil { debugPrint("Faulty Project reference in Comment with id \(id).")}
    if poster == nil { debugPrint("Faulty Poster reference in Comment with id \(id).")}
  }

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel.setValuesForKeys([
      "timestamp": timestamp,
      "content": content,
      "project": CKRecord.Reference(
        recordID: .init(recordName: project.description),
        action: .deleteSelf
      ),
      "poster": CKRecord.Reference(
        recordID: .init(recordName: poster),
        action: .deleteSelf
      )
    ])

    return remoteModel
  }
}

// fetching references

extension Comment {
  func withProject(_ project: Project.Shared) -> WithProject { WithProject(self, project: project) }
  
  func withPoster(_ poster: User) -> WithPoster { WithPoster(self, poster: poster) }

  func attachProject(_ service: RemoteDBService) async throws -> WithProject? {
    try await fetchProject(service).flatMap(withProject)
  }

  func attachPoster(_ service: RemoteDBService) async throws -> WithPoster? {
    try await fetchPoster(service).flatMap(withPoster)
  }
  
  func fetchProject(_ service: RemoteDBService) async throws -> Project.Shared? {
    try await service.fetch(with: project)
  }
  
  func fetchPoster(_ service: RemoteDBService) async throws -> User? {
    try await service.fetch(with: poster)
  }
}
