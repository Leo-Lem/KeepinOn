//
//  Item.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import CoreData
import MyData
import MyOthers

@objc(CDItem)
class CDItem: NSManagedObject {}

/// The Swift representation of the CoreData (CD)Item.
/// Makes it a lot easier and safer to work with the Core Data objects imo.
struct Item: CDRepresentable {
    
    let cd: CDItem
    
    init(_ cd: CDItem) { self.cd = cd }
    
    init?(_ cd: CDItem?) {
        if let cd = cd { self.cd = cd  } else { return nil }
    }
    
    func update() {
        cd.objectWillChange.send()
        project?.cd.objectWillChange.send()
    }
    
}

extension Item {
    
    var project: Project? {
        get { Project(cd.project) }
        set { cd.project ?= newValue?.cd }
    }

    var title: String? {
        get { cd.title }
        set { cd.title = newValue }
    }

    var details: String {
        get { cd.details ?? "" }
        set { cd.details = newValue }
    }

    var priority: Priority {
        get { Priority(rawValue: Int(cd.priority)) ?? .low }
        set { cd.priority = Int16(newValue.rawValue) }
    }
    
    enum Priority: Int, Equatable, Comparable, CaseIterable {
        case low = 1, mid = 2, high = 3
        
        static func == (lhs: Self, rhs: Self) -> Bool { lhs.rawValue == rhs.rawValue }
        static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }
    }

    var completed: Bool {
        get { cd.completed }
        set { cd.completed = newValue }
    }

    var timestamp: Date { cd.timestamp ?? Date() }

    /// Initializes an Item by inserting a CDItem into the
    /// provided context and settings the parameters
    /// - Parameters:
    ///   - context: An NSManagedObjectContext to insert the (underlying) CDItem into.
    ///   - title: The title of the item (optional). Defaults to nil.
    ///   - details: The details describing the item closer. Defaults to "".
    ///   - priority: The priority of the item. Defaults to .low.
    init(
        in context: NSManagedObjectContext,
        project: Project? = nil,
        title: String? = nil,
        details: String = "",
        priority: Priority = .low
    ) {
        self.cd = CDItem(context: context)
        self.cd.timestamp = Date()

        self.completed = false

        self.title = title
        self.details = details
        self.priority = priority
        self.project ?= project
    }

}

extension Item: Identifiable { var id: ObjectIdentifier { cd.id } }

#if DEBUG
// MARK: - (Example)
extension Item {

    static var example: Item {
        Item(
            in: DataController(inMemory: true).context,
            title: "Example Item",
            details: "This is an example item",
            priority: .high
        )
    }

}
#endif
