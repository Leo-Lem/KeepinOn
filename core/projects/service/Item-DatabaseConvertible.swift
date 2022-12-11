//	Created by Leopold Lemmermann on 25.10.22.

import Foundation
import CoreDataService
import IndexingService

extension Item: DatabaseObjectConvertible {
  static let typeID = "Item"

  init(from localModel: CDItem) {
    self.init(
      id: localModel.id ?? UUID(),
      timestamp: localModel.timestamp ?? .now,
      title: localModel.title ?? "",
      details: localModel.details ?? "",
      isDone: localModel.isDone,
      priority: Item.Priority(rawValue: Int(localModel.priority)) ?? .low,
      project: localModel.project ?? Project.ID()
    )
  }

  func mapProperties(onto localModel: inout CDItem) {
    localModel.id = id
    localModel.timestamp = timestamp
    localModel.title = title
    localModel.details = details
    localModel.isDone = isDone
    localModel.priority = Int16(priority.rawValue)
    localModel.project = project
  }
}

extension Item: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isDone: "isDone",
    \.priority: "priority",
    \.project: "project"
  ]
}

extension Item: Indexable {}
