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
}
