//	Created by Leopold Lemmermann on 08.10.22.

@testable import KeepinOn
import XCTest

final class CDServiceTests: XCTestCase {
  private var service: CDService!

  override func setUp() async throws {
    service = CDService(inMemory: true)
  }

  func testInserting() throws {
    let model = Project(title: "Some Project")
    try service.insert(model)

    let inserted: Project? = try service.fetch(with: model.id)
    XCTAssertEqual(model, inserted, "Models don't match after insertion.")
  }

  func testUpdating() throws {
    let model = Project(title: "Some Project")
    try service.insert(model)
    let newModel = Project(
      id: model.id,
      timestamp: model.timestamp,
      title: "Some new title",
      items: model.items
    )
    try service.insert(newModel)

    let updated: Project? = try service.fetch(with: model.id)
    XCTAssertEqual(newModel, updated, "The updated model doesn't match.")
  }

  func testDeleting() throws {
    let model = Project.example
    try service.insert(model)

    try service.delete(with: model.id)
    let deleted: Project? = try service.fetch(with: model.id)

    XCTAssertNil(deleted, "Project was not deleted.")
  }

  func testCounting() throws {
    for _ in 0 ..< 5 {
      try service.insert(Project.example)
    }

    let result = try service.fetch(Query<Project>(true))
    XCTAssertEqual(result.count, 5, "Project count doesn't make sense.")
  }

  func testFetching() throws {
    let model = Project(
      title: "This is the title",
      details: "These are some details",
      isClosed: true
    )
    try service.insert(model)

    let queries: [Query<Project>] = [
      .init(\.title, .eq, model.title),
      .init(\.details, .neq, "Some other details."),
      .init(\.isClosed, .eq, model.isClosed)
    ]

    for query in queries {
      let result = try service.fetch(query)
      XCTAssert(result.contains(model), "\(query) does not find the \(model).")
    }
  }
}
