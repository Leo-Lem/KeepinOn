//	Created by Leopold Lemmermann on 07.10.22.

import Colors
import Foundation

struct Project: Identifiable, Equatable, Hashable, Codable {
  let id: UUID
  let timestamp: Date

  var title: String
  var details: String
  var isClosed: Bool
  var colorID: ColorID
  var reminder: Reminder
  var items: [Item.ID]

  init(
    id: ID = ID(),
    timestamp: Date = .now,
    title: String = "",
    details: String = "",
    isClosed: Bool = false,
    colorID: ColorID = .darkBlue,
    reminder: Reminder = nil,
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

  typealias Reminder = Date?
}
