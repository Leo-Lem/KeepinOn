//	Created by Leopold Lemmermann on 25.10.22.

import Colors
import CoreDataService
import Foundation
import IndexingService

extension Project: DatabaseObjectConvertible {
  static let typeID = "Project"

  init(from localModel: CDProject) {
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

  func mapProperties(onto localModel: inout CDProject) {
    localModel.id = id
    localModel.timestamp = timestamp
    localModel.title = title
    localModel.details = details
    localModel.isClosed = isClosed
    localModel.colorID = colorID.rawValue
    localModel.reminder = reminder
    localModel.items = items
  }
}

extension Project: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isClosed: "isClosed",
    \.colorID: "colorID",
    \.reminder: "reminder"
  ]
}

extension Project: Indexable {}
