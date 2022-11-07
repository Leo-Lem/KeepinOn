//	Created by Leopold Lemmermann on 27.10.22.

import Foundation

extension Item: Queryable {
  static let keyPathDictionary: [PartialKeyPath<Self>: String] = [
    \.id: "id",
    \.title: "title",
    \.details: "details",
    \.isDone: "isDone",
    \.priority: "priority",
    \.project?.id: "project.id",
    \.project?.title: "project.title",
    \.project?.details: "project.details",
    \.project?.isClosed: "project.isClosed",
    \.project?.colorID: "project.colorID",
    \.project?.reminder: "project.reminder"
  ]
}
