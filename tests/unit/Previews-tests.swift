//	Created by Leopold Lemmermann on 28.11.22.

import CloudKitService
import CoreDataService
@testable import KeepinOn
import XCTest

final class PreviewsTests: XCTestCase {
  var mainState: MainState!

  override func setUp() async throws { mainState = await MainState() }

  @MainActor func testDatabaseService() async throws {
    await (mainState.privateDBService as? CoreDataService)!.createSampleData()

    var condition = try await mainState.privateDBService.fetchAndCollect(Query<Project>(true)).count > 0
    XCTAssertTrue(condition, "No projects were created.")

    condition = try await mainState.privateDBService.fetchAndCollect(Query<Item>(true)).count > 0
    XCTAssertTrue(condition, "No items were created.")

    await (mainState.privateDBService as? CoreDataService)!.deleteAll()
    
    condition = try await mainState.privateDBService.fetchAndCollect(Query<Project>(true)).count == 0
    XCTAssertTrue(condition, "Projects still exists.")

    condition = try await mainState.privateDBService.fetchAndCollect(Query<Item>(true)).count == 0
    XCTAssertTrue(condition, "Items still exist.")
  }

  @MainActor func testRemoteDatabaseService() async throws {
    guard case .available = await mainState.publicDBService.status else { throw XCTSkip("Can't access CloudKit.") }

    await (mainState.publicDBService as? CloudKitService)!.createSampleData()

    var project = try await mainState.publicDBService
      .fetchAndCollect(Query<SharedProject>(true, options: .init(maxItems: 1))).first

    XCTAssertNotNil(project, "No project was created.")

    await (mainState.publicDBService as? CloudKitService)!.deleteAll()

    try? await Task.sleep(for: .seconds(1))

    project = try await mainState.publicDBService
      .fetchAndCollect(Query<SharedProject>(true, options: .init(maxItems: 1))).first

    XCTAssertNil(project, "Project still exists.")
  }
}
