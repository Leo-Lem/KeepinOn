//	Created by Leopold Lemmermann on 20.10.22.

@testable import KeepinOn
import XCTest
import SwiftUI

class AssetTests: XCTestCase {
  func testColorsExist() {
    for asset in ColorID.allCases.map(\.asset) {
      XCTAssertNotNil(Color(asset), "Failed to load color '\(asset)' from the asset catalog.")
    }
  }

  func testAwardsLoadCorrectly() {
    XCTAssertFalse(Award.all.isEmpty, "Failed to load awards from JSON.")
  }
}
