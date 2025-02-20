//  Created by Leopold Lemmermann on 05.10.22.

import Foundation

@Model public class Item: @unchecked Sendable {
  public var createdAt: Date

  public var title: String
  public var details: String
  public var priority: Priority?
  public var done: Bool

  public var project: Project?

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

public extension DependencyValues {
  var items: Database<Item> {
    get { self[Database<Item>.self] }
    set { self[Database<Item>.self] = newValue }
  }
}
