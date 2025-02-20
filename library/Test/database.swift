// Created by Leopold Lemmermann on 15.02.25.

@testable import SwiftDatabase
import Testing

@Model class TestModel {
  var id: Int
  init(id: Int = .random(in: 0..<1000)) { self.id = id }
}

extension DependencyValues {
  var database: Database<TestModel> {
    get { self[Database<TestModel>.self] }
    set { self[Database<TestModel>.self] = newValue }
  }
}

@Suite(.serialized) @MainActor struct DatabaseTests {
  let context: ModelContext
  let model = TestModel()

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

    try context.save()
    try context.delete(model: TestModel.self)
  }

  @Test func insertingAndDeleting() async throws {
    #expect(try context.fetch(FetchDescriptor<TestModel>()).isEmpty)
    context.insert(model)
    #expect(try context.fetch(FetchDescriptor<TestModel>()).count == 1)
    context.delete(model)
    #expect(try context.fetch(FetchDescriptor<TestModel>()).isEmpty)
  }

  @Test func differentContext() async throws {
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

  @Test func inserting() async throws {
    try await withDependencies {
      $0.data = .liveValue
      $0.database = .liveValue
    } operation: {
      @Dependency(\.database.insert) var insert
      try await insert(model)
      #expect(try context.fetch(FetchDescriptor<TestModel>()).count == 1)
    }
  }

  @Test func fetching() async throws {
    try await withDependencies {
      $0.data = .liveValue
      $0.database = .liveValue
    } operation: {
      context.insert(model)
      @Dependency(\.database.fetch) var fetch

      let result = try await fetch(FetchDescriptor<TestModel>())

      #expect(result.count == 1)
    }
  }

  @Test func deleting() async throws {
    try await withDependencies {
      $0.data = .liveValue
      $0.database = .liveValue
    } operation: {
      context.insert(model)
      @Dependency(\.database.delete) var delete

      try await delete(model)

      let result = try context.fetch(FetchDescriptor<TestModel>())
      #expect(result.count == 0)
    }
  }
}
