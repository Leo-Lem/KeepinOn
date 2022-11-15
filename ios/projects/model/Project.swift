//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

struct Project: Identifiable, Hashable, Codable {
  let id: UUID, timestamp: Date

  var title: String,
      details: String,
      isClosed: Bool,
      colorID: ColorID,
      reminder: Date?,
      items: [Item.ID]

  init(
    id: ID = ID(),
    timestamp: Date = .now,
    title: String = "",
    details: String = "",
    isClosed: Bool = false,
    colorID: ColorID = .darkBlue,
    reminder: Date? = nil,
    items: [Item.ID] = []
  ) {
    self.id = id
    self.timestamp = timestamp
    self.title = title
    self.details = details
    self.isClosed = isClosed
    self.colorID = colorID
    self.reminder = reminder
    self.items = items
  }
}

extension Project {
  mutating func addItem(_ item: Item) { self.items.append(item.id) }
}

extension Project {
  struct WithItems: Identifiable, Hashable, Codable {
    let project: Project,
        items: [Item]
    
    var id: Project.ID { project.id }
    
    init(_ project: Project, items: [Item]) {
      self.project = project
      self.items = items
    }
  }
}
