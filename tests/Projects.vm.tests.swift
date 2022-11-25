//	Created by Leopold Lemmermann on 24.11.22.

@testable import KeepinOn
import XCTest

@MainActor
class ProjectsVMTests: XCTestCase {
  var vm: ProjectsView.ViewModel!

  override func setUp() {
    vm = ProjectsView.ViewModel(closed: false, dismiss: {}, mainState: .mock)
  }

  func testAddingProject() {
//    let count = vm.projects.count
//
//    vm.addProject()
//    
//    XCTAssertEqual(vm.projects.count, count + 1, "The project was not added.")
  }

  func testAddingItem() {
//    vm.addProject()
//    guard let project = vm.projects.first else { return XCTFail("Couldn't add project.") }
//
//    let count = vm.items[project.id]?.count
//
//    vm.addItem(to: project)
//
//    XCTAssertEqual(vm.items[project.id]?.count, count, "The item was not added.")
  }
}
