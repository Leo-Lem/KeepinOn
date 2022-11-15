//	Created by Leopold Lemmermann on 25.10.22.

import CloudKit

extension Item.Shared: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "Item"

  init(from remoteModel: RemoteModel) {
    let id = UUID(uuidString: remoteModel.recordID.recordName) ?? UUID()
    let project = remoteModel["project"] as? CKRecord.Reference

    self.init(
      id: id,
      title: remoteModel["title"] as? String ?? "",
      details: remoteModel["details"] as? String ?? "",
      isDone: remoteModel["isDone"] as? Bool ?? false,
      project: (project?.recordID.recordName)
        .flatMap(Project.Shared.ID.init) ?? Project.Shared.ID()
    )

    if project == nil { debugPrint("Faulty Project reference in Item with id \(id).") }
  }

  func mapProperties(onto remoteModel: CKRecord) -> CKRecord {
    remoteModel.setValuesForKeys([
      "title": title,
      "details": details,
      "isDone": isDone,
      "project": CKRecord.Reference(
        recordID: .init(recordName: project.description),
        action: .deleteSelf
      )
    ])

    return remoteModel
  }
}

// fetching references

extension Item.Shared {
  func withProject(_ project: Project.Shared) -> WithProject { WithProject(self, project: project) }

  func attachProject(_ service: RemoteDBService) async throws -> WithProject? {
    try await fetchProject(service).flatMap(withProject)
  }
  
  func fetchProject(_ service: RemoteDBService) async throws -> Project.Shared? {
    try await service.fetch(with: project)
  }
}
