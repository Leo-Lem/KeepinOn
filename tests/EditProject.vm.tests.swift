//	Created by Leopold Lemmermann on 24.11.22.

@testable import KeepinOn
import XCTest

@MainActor
class EditProjectVMTests: XCTestCase {
  var vm: Project.EditingView.ViewModel!
  
  override func setUp() async throws {
    vm = await Project.EditingView.ViewModel(.example, dismiss: {}, mainState: .mock)
  }
  
  
}
