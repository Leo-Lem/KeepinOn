//	Created by Leopold Lemmermann on 25.10.22.

extension Project: PrivConvertible {
  typealias PrivateModel = CDProject
  static let typeID = "Project"

  init(from privateModel: PrivateModel) {
    // prevents memory leaks through infinite adding of projects and items
    self.init(
      id: privateModel.id ?? UUID(),
      timestamp: privateModel.timestamp ?? .now,
      title: privateModel.title ?? "",
      details: privateModel.details ?? "",
      isClosed: privateModel.isClosed,
      colorID: ColorID(rawValue: privateModel.colorID ?? "") ?? .darkBlue,
      reminder: privateModel.reminder,
      items: privateModel.items ?? []
    )
  }

  func mapProperties(onto privateModel: PrivateModel) -> PrivateModel {
    privateModel.id = id
    privateModel.timestamp = timestamp
    privateModel.title = title
    privateModel.details = details
    privateModel.isClosed = isClosed
    privateModel.colorID = colorID.rawValue
    privateModel.reminder = reminder
    privateModel.items = items

    return privateModel
  }
}

extension Project {
  func fetchItems(_ service: PrivDBService) -> [Item] {
    printError {
      try items.map(\.uuidString).compactMap(service.fetch)
    } ?? []
  }
  
  func attachItems(_ service: PrivDBService) -> WithItems {
    WithItems(self, service: service)
  }
}

extension Project.WithItems {
  init(_ project: Project, service: PrivDBService) {
    self.init(project, items: project.fetchItems(service))
  }
  
  func revertRelationship() -> [Item.WithProject] {
    items.map { item in Item.WithProject(item, project: project) }
  }
}
