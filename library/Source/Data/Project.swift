//  Created by Leopold Lemmermann on 07.10.22.

import Foundation
import SwiftData

@Model public class Project {
  public var createdAt: Date

  public var title: String
  public var details: String
  public var accent: Accent
  public var closed: Bool

  public var items: [Item]

  public init(
    createdAt: Date = .now,
    title: String,
    details: String,
    accent: Accent,
    closed: Bool = false,
    items: [Item] = []
  ) {
    self.createdAt = createdAt
    self.title = title
    self.details = details
    self.accent = accent
    self.closed = closed
    self.items = items
  }
}

