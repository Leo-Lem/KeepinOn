//  Created by Leopold Lemmermann on 05.10.22.

import Foundation
import SwiftData

@Model public class Item {
  var createdAt: Date

  var title: String
  var details: String
  var priority: Priority?
  var done: Bool

  var project: Project?

  public init(
    createdAt: Date = .now,
    title: String,
    details: String,
    priority: Priority? = nil,
    done: Bool = false,
    project: Project? = nil
  ) {
    self.createdAt = createdAt
    self.title = title
    self.details = details
    self.priority = priority
    self.done = done
    self.project = project
  }
}
