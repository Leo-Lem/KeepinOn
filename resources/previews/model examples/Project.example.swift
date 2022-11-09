//	Created by Leopold Lemmermann on 07.10.22.

import Foundation

extension Project: HasExample {
  static var example: Project {
    Project(
      title: "Project No. \(Int.random(in: 1 ..< 100))",
      details: "This is an example project",
      isClosed: .random(),
      colorID: .allCases.randomElement() ?? .darkBlue,
      items: [UUID(), UUID(), UUID()]
    )
  }
}
