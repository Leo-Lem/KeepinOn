//	Created by Leopold Lemmermann on 28.10.22.

import CloudKit

extension User: RemoteConvertible {
  typealias RemoteModel = CKRecord
  static let typeID = "User"

  init(from remoteModel: RemoteModel) {
    let id = remoteModel.recordID.recordName
    let projects = remoteModel["projects"] as? [CKRecord.Reference]
    let comments = remoteModel["comments"] as? [CKRecord.Reference]

    self.init(
      id: remoteModel.recordID.recordName,
      name: remoteModel["name"] as? String ?? "",
      colorID: ColorID(rawValue: remoteModel["colorID"] as? String ?? "") ?? .darkBlue,
      progress: (remoteModel["progress"] as? Data)
        .flatMap { data in
          try? JSONDecoder().decode(Award.Progress.self, from: data)
        } ?? Award.Progress(),
      projects: projects?
        .map(\.recordID.recordName)
        .compactMap(Project.Shared.ID.init) ?? [],
      comments: comments?
        .map(\.recordID.recordName)
        .compactMap(Comment.ID.init) ?? []
    )

    if projects == nil { debugPrint("Faulty Projects reference in User with id \(id).") }
    if comments == nil { debugPrint("Faulty Comments reference in User with id \(id).") }
  }

  func mapProperties(onto remoteModel: RemoteModel) -> RemoteModel {
    remoteModel.setValuesForKeys([
      "name": name,
      "colorID": colorID.rawValue,
      "progress": (try? JSONEncoder().encode(progress)) ?? Data(),
      "projects": projects
        .map(\.description)
        .map(CKRecord.ID.init)
        .map { CKRecord.Reference(recordID: $0, action: .none) },
      "comments": comments
        .map(\.description)
        .map(CKRecord.ID.init)
        .map { CKRecord.Reference(recordID: $0, action: .none) }
    ])

    return remoteModel
  }
}

extension User {
  func attachComments(_ service: RemoteDBService) async throws -> WithComments {
    WithComments(self, comments: try await fetchComments(service).collect())
  }

  func attachProjects(_ service: RemoteDBService) async throws -> WithProjects {
    WithProjects(self, projects: try await fetchProjects(service).collect())
  }

  func fetchComments(_ service: RemoteDBService) -> AsyncThrowingStream<Comment, Error> {
    service.fetch(with: comments)
  }

  func fetchProjects(_ service: RemoteDBService) -> AsyncThrowingStream<Project.Shared, Error> {
    service.fetch(with: projects)
  }
}
