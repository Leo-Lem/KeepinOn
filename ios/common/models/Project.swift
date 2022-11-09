//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

struct Project: Identifiable, Hashable, Codable {
  let id: UUID, timestamp: Date

  var title: String,
      details: String,
      isClosed: Bool,
      colorID: ColorID,
      reminder: Date?,
      items: [UUID]

  init(
    id: UUID = UUID(),
    timestamp: Date = .now,
    title: String = "",
    details: String = "",
    isClosed: Bool = false,
    colorID: ColorID = .darkBlue,
    reminder: Date? = nil,
    items: [UUID] = []
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
