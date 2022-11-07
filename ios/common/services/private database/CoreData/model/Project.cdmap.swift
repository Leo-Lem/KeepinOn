//	Created by Leopold Lemmermann on 25.10.22.

import CoreData

extension Project: CDConvertible {
  typealias CDModel = CDProject
  static let cdIdentifier = "Project"

  init(from cdProject: CDProject, withRelationships: Bool = true) {
    // prevents memory leaks through infinite adding of projects and items
    let items = withRelationships ?
      cdProject.getCDItems().compactMap { Item(from: $0) }
      : nil

    self.init(
      id: cdProject.id ?? UUID(),
      timestamp: cdProject.timestamp ?? .now,
      title: cdProject.title ?? "",
      details: cdProject.details ?? "",
      isClosed: cdProject.isClosed,
      colorID: ColorID(rawValue: cdProject.colorID ?? "") ?? .darkBlue,
      reminder: cdProject.reminder,
      items: items ?? []
    )
  }

  func mapToCDModel(in context: NSManagedObjectContext) -> CDModel {
    let cdProject = context.fetch(with: id) ??
      NSEntityDescription.insertNewObject(forEntityName: Self.cdIdentifier, into: context) as? CDModel ??
      CDModel(context: context)

    cdProject.id = id
    cdProject.timestamp = timestamp
    cdProject.title = title
    cdProject.details = details
    cdProject.isClosed = isClosed
    cdProject.colorID = colorID.rawValue
    cdProject.reminder = reminder

    context.insert(cdProject)

    for item in items {
      let cdItem = context.fetch(with: item.id) as CDItem? ?? item.mapToCDModel(in: context)
      cdProject.addToItems(cdItem)
    }

    return cdProject
  }
}

extension CDProject {
  func getCDItems() -> [CDItem] {
    items?.compactMap { $0 as? CDItem } ?? []
  }
}
