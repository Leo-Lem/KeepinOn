// Created by Leopold Lemmermann on 15.02.25.

@testable import Database
import Testing

@MainActor struct DatabaseTests {
  @Model class TestModel {
    var id: Int
    init(id: Int = .random(in: 0..<1000)) { self.id = id }
  }

  let context: ModelContext

  init() async throws {
    SwiftDatabase.container = try ModelContainer(
      for: TestModel.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    self.context = withDependencies {
      $0.data = .liveValue
    } operation: {
      @Dependency(\.data.context) var makeContext
      return makeContext()
    }
  }

  @Test func insertingAndDeleting() async throws {
    let model = TestModel()
    #expect(try context.fetch(FetchDescriptor<TestModel>()).isEmpty)
    context.insert(model)
    #expect(try context.fetch(FetchDescriptor<TestModel>()).count == 1)
    context.delete(model)
    #expect(try context.fetch(FetchDescriptor<TestModel>()).isEmpty)
  }

  @Test func differentContext() async throws {
    let model = TestModel()
    #expect(try context.fetch(FetchDescriptor<TestModel>()).isEmpty)
    context.insert(model)
    #expect(try context.fetch(FetchDescriptor<TestModel>()).count == 1)

    let otherContext = withDependencies {
      $0.data = .liveValue
    } operation: {
      @Dependency(\.data.context) var makeContext
      return makeContext()
    }

    #expect(try otherContext.fetch(FetchDescriptor<TestModel>()).count == 1)
    context.delete(model)
    #expect(try context.fetch(FetchDescriptor<TestModel>()).isEmpty)
  }
}
