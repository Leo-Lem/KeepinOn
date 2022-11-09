//	Created by Leopold Lemmermann on 25.10.22.

extension Item: PrivConvertible {
  typealias PrivateModel = CDItem
  static let typeID = "Item"

  init(from privateModel: PrivateModel) {
    self.init(
      id: privateModel.id ?? UUID(),
      timestamp: privateModel.timestamp ?? .now,
      title: privateModel.title ?? "",
      details: privateModel.details ?? "",
      isDone: privateModel.isDone,
      priority: Item.Priority(rawValue: Int(privateModel.priority)) ?? .low,
      project: privateModel.project!
    )
  }

  func mapProperties(onto privateModel: PrivateModel) -> PrivateModel {
    privateModel.id = id
    privateModel.timestamp = timestamp
    privateModel.title = title
    privateModel.details = details
    privateModel.isDone = isDone
    privateModel.priority = Int16(priority.rawValue)
    privateModel.project = project

    return privateModel
  }
}

extension Item {
  func fetchProject(_ service: PrivDBService) -> Project? {
    printError {
      try service.fetch(with: project.uuidString)
    }
  }
  
  func attachProject(_ service: PrivDBService) -> WithProject? {
    WithProject(self, service: service)
  }
}

extension Item.WithProject {
  init?(_ item: Item, service: PrivDBService) {
    guard let project = item.fetchProject(service) else { return nil }
    self.init(item, project: project)
  }
}
