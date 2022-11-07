//  Created by Leopold Lemmermann on 08.10.22.

@testable import KeepinOn
import XCTest

final class CKServiceTests: XCTestCase {
  private var service: CKService!

  override func setUp() async throws {
    service = await CKService()

    // verifies the user has permissions for writing to the cloudkit database
    guard case .available = service.status else {
      throw XCTSkip("Cannot access CloudKit.")
    }

    // cleans up any leftover data
    await service.deleteAll()

    // leaving a little time for the serverside actions
    try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
  }

  func testPublishing() async throws {
    let model = getRandomModel()
    try await service.publish(model)
  }

  func testUnpublishing() async throws {
    let model = getRandomModel()
    try await service.publish(model)

    try await service.unpublish(with: getIDFrom(model: model))
  }

  func testExists() async throws {
    let model = getRandomModel()
    var result = try await service.exists(with: getIDFrom(model: model))
    XCTAssertFalse(result, "Model exists without inserting.")

    try await service.publish(model)
    result = try await service.exists(with: getIDFrom(model: model))
    XCTAssertTrue(result, "Model does not exist after inserting.")
  }

  func testFetching() async throws {
    await service.createSampleData()

    let result: [Project.Shared] = try await service.fetch(Query<Project.Shared>(true))
    XCTAssertFalse(result.isEmpty, "No projects were fetched.")
  }

  func testFetchingReferencesTo() async throws {
    let project = Project.Shared.example
    try await service.publish(project)

    let item = Item.Shared(
      id: UUID(),
      project: project,
      title: "Some Item",
      details: "Some Details",
      isDone: false
    )
    try await service.publish(item)

    try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)

    let result: [Item.Shared] = try await service.fetchReferencesToModel(project)
    XCTAssertTrue(result.contains { $0.id == item.id }, "The Item is not found via reference to project.")
  }
}

private extension CKServiceTests {
  func getRandomModel() -> PublicModelConvertible {
    switch Int.random(in: 0 ... 2) {
    case 0: return Comment.example
    case 1: return Item.Shared.example
    default: return Project.Shared.example
    }
  }

  func getIDFrom(model: PublicModelConvertible) -> UUID {
    switch model {
    case let project as Project.Shared: return project.id
    case let item as Item.Shared: return item.id
    case let comment as Comment: return comment.id
    default: return UUID()
    }
  }
}
