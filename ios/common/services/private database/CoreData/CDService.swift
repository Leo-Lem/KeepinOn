//	Created by Leopold Lemmermann on 07.10.22.

import Combine
import CoreData
import UIKit
import WidgetKit

final class CDService: PrivateDatabaseService {
  let didChange = PassthroughSubject<Void, Never>()

  private var container: NSPersistentCloudKitContainer!
  private var indexingService: IndexingService?
  private var tasks = Tasks()

  init(
    inMemory: Bool = false,
    indexingService: IndexingService? = nil
  ) {
    self.indexingService = indexingService

    container = createContainer(inMemory: inMemory)
    loadPersistentStores()
    tasks.add(updateOnChange(), saveOnResignActive())
  }

  @discardableResult
  func insert<T: PrivateModelConvertible>(_ model: T) throws -> T {
    let object = try mapToNSManagedObject(model, context: context)
    context.insert(object)

    if let indexable = model as? Indexable {
      indexingService?.updateReference(to: indexable)
    }

    try save()

    return model
  }

  func delete(with id: UUID) throws {
    if let obj: CDProject = context.fetch(with: id) {
      context.delete(obj)
    } else if let obj: CDItem = context.fetch(with: id) {
      context.delete(obj)
    }

    try save()

    indexingService?.removeReference(with: id)
  }

  func count<T: PrivateModelConvertible>(_ query: Query<T>) throws -> Int {
    try mapError {
      let request = try getNSFetchRequest(from: query)
      let result = try context.count(for: request)
      return result
    }
  }

  func fetch<T: PrivateModelConvertible>(_ query: Query<T>) throws -> [T] {
    try mapError {
      let request = try getNSFetchRequest(from: query)
      let result = try context.fetch(request)
      return try result
        .compactMap { $0 as? NSManagedObject }
        .compactMap { try mapFromNSManagedObject($0) }
    }
  }
}

private extension CDService {
  static let containerID = "Main"

  static let managedObjectModel: NSManagedObjectModel = {
    guard
      let url = Bundle.main.url(forResource: CDService.containerID, withExtension: "momd"),
      let managedObjectModel = NSManagedObjectModel(contentsOf: url)
    else {
      fatalError("Failed to load model file.")
    }

    return managedObjectModel
  }()

  var context: NSManagedObjectContext { container.viewContext }

  func createContainer(inMemory: Bool) -> NSPersistentCloudKitContainer {
    let container = NSPersistentCloudKitContainer(
      name: Self.containerID,
      managedObjectModel: Self.managedObjectModel
    )

    if inMemory {
      container.persistentStoreDescriptions.first?
        .url = URL(filePath: "/dev/null")
    } else {
      container.persistentStoreDescriptions.first?.url = config.containerURL
        .appendingPathComponent("\(Self.containerID).sqlite")
    }

    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    return container
  }

  func loadPersistentStores() {
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Failed to load persistent store: \(error.localizedDescription)")
      }
    }
  }

  func save() throws {
      try context.saveIfChanged()
  }

  func updateOnChange() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: .NSManagedObjectContextObjectsDidChange)
      .getTask { [weak self] _ in
        self?.didChange.send()
        // updating widgets on coredata changes
        WidgetCenter.shared.reloadAllTimelines()
      }
  }

  func saveOnResignActive() -> Task<Void, Never> {
    NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .getTask { [weak self] _ in
        do { try self?.save() } catch { print(error.localizedDescription) }
      }
  }
}

private extension CDService {
  func mapError<T>(_ action: () throws -> T) rethrows -> T {
    do {
      return try action()
    } catch let error as PrivateDatabaseError {
      throw error
    } catch {
      throw PrivateDatabaseError.other(error)
    }
  }

  func mapError<T>(_ action: () async throws -> T) async rethrows -> T {
    do {
      return try await action()
    } catch let error as PrivateDatabaseError {
      throw error
    } catch {
      throw PrivateDatabaseError.other(error)
    }
  }
}
