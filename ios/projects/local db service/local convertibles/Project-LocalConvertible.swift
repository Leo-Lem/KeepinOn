//	Created by Leopold Lemmermann on 25.10.22.

import Errors

extension Project: LocalConvertible {
  typealias LocalModel = CDProject
  static let typeID = "Project"

  init(from localModel: LocalModel) {
    // prevents memory leaks through infinite adding of projects and items
    self.init(
      id: localModel.id ?? UUID(),
      timestamp: localModel.timestamp ?? .now,
      title: localModel.title ?? "",
      details: localModel.details ?? "",
      isClosed: localModel.isClosed,
      colorID: ColorID(rawValue: localModel.colorID ?? "") ?? .darkBlue,
      reminder: localModel.reminder,
      items: localModel.items ?? []
    )
  }

  func mapProperties(onto localModel: LocalModel) -> LocalModel {
    localModel.id = id
    localModel.timestamp = timestamp
    localModel.title = title
    localModel.details = details
    localModel.isClosed = isClosed
    localModel.colorID = colorID.rawValue
    localModel.reminder = reminder
    localModel.items = items

    return localModel
  }
}

// fetching references

extension Project {
  func fetchItems(_ service: LocalDBService) -> [Item] {
    printError {
      try items.compactMap(service.fetch)
    } ?? []
  }

  func attachItems(_ service: LocalDBService) -> WithItems {
    WithItems(self, service: service)
  }
}

extension Project.WithItems {
  init(_ project: Project, service: LocalDBService) {
    self.init(project, items: project.fetchItems(service))
  }

  func revertRelationship() -> [Item.WithProject] {
    items.map { item in Item.WithProject(item, project: project) }
  }
}
