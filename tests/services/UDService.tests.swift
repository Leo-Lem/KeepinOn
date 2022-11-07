//	Created by Leopold Lemmermann on 31.10.22.

@testable import KeepinOn
import XCTest

final class UDServiceTests: XCTestCase {
  private var service: UDService!

  override func setUp() {
    service = UDService()
  }

  func testInsertingItem() throws {
    let item = "Hello there",
        key = "key"

    XCTAssertNoThrow(try service.insert(item, for: key), "The item couldn't be inserted.")
  }

  func testDeletingItem() throws {
    let item = "Hello there",
        key = "key"

    try service.insert(item, for: key)
    try service.delete(for: key)

    XCTAssertNil(try service.load(for: key) as String?, "The item was not deleted.")
  }

  func testFetchingItem() throws {
    let item = "Hello there",
        key = "key"

    try service.insert(item, for: key)

    XCTAssertEqual(item, try service.load(for: key), "The item was not fetched.")
  }
}
