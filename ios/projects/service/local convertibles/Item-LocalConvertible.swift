//	Created by Leopold Lemmermann on 25.10.22.

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
      project: localModel.project ?? Project.ID()
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
