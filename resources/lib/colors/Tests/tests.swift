import Colors
import XCTest
import SwiftUI

final class ColorsTests: XCTestCase {
  func testLoadingColor() {
    for colorID in ColorID.allCases {
      XCTAssertNotNil(Color(colorID.asset), "Color asset for \(colorID) was not found.")
    }
  }
}
