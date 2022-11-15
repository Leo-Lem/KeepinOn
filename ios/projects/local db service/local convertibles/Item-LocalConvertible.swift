//	Created by Leopold Lemmermann on 25.10.22.

import Errors

extension Item: LocalConvertible {
  typealias LocalModel = CDItem
  static let typeID = "Item"

  init(from localModel: LocalModel) {
    self.init(
      id: localModel.id ?? UUID(),
      timestamp: localModel.timestamp ?? .now,
      title: localModel.title ?? "",
      details: localModel.details ?? "",
      isDone: localModel.isDone,
      priority: Item.Priority(rawValue: Int(localModel.priority)) ?? .low,
      project: localModel.project!
    )
  }

  func mapProperties(onto localModel: LocalModel) -> LocalModel {
    localModel.id = id
    localModel.timestamp = timestamp
    localModel.title = title
    localModel.details = details
    localModel.isDone = isDone
    localModel.priority = Int16(priority.rawValue)
    localModel.project = project

    return localModel
  }
}

// fetching references

extension Item {
  func fetchProject(_ service: LocalDBService) -> Project? {
    printError {
      try service.fetch(with: project)
    }
  }
  
  func attachProject(_ service: LocalDBService) -> WithProject? {
    WithProject(self, service: service)
  }
}

extension Item.WithProject {
  init?(_ item: Item, service: LocalDBService) {
    guard let project = item.fetchProject(service) else { return nil }
    self.init(item, project: project)
  }
}
