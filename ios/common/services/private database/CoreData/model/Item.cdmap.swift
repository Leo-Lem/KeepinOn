//	Created by Leopold Lemmermann on 25.10.22.

import CoreData

extension Item: CDConvertible {
  typealias CDModel = CDItem
  static let cdIdentifier = "Item"

  init(from cdItem: CDItem, withRelationships: Bool = true) {
    // prevents memory leaks through infinite adding of projects and items
    let project: Project? = withRelationships ?
      cdItem.project.flatMap { Project(from: $0, withRelationships: false) } :
      nil

    self.init(
      id: cdItem.id ?? UUID(),
      timestamp: cdItem.timestamp ?? .now,
      title: cdItem.title ?? "",
      details: cdItem.details ?? "",
      isDone: cdItem.isDone,
      priority: Item.Priority(rawValue: Int(cdItem.priority)) ?? .low,
      project: project
    )
  }

  func mapToCDModel(in context: NSManagedObjectContext) -> CDModel {
    let cdItem: CDModel = context.fetch(with: id) ??
      NSEntityDescription.insertNewObject(forEntityName: Self.cdIdentifier, into: context) as? CDModel ??
      CDModel(context: context)

    cdItem.id = id
    cdItem.timestamp = timestamp
    cdItem.title = title
    cdItem.details = details
    cdItem.isDone = isDone
    cdItem.priority = Int16(priority.rawValue)

    context.insert(cdItem)

    cdItem.project = context.fetch(with: id) as CDProject? ?? project?.mapToCDModel(in: context)

    return cdItem
  }
}

extension CDItem {
  func hasProjectWith(id: UUID) -> Bool {
    project?.id == id
  }
}
