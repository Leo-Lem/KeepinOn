//
//  Project.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import CoreData
import MyData
import MyOthers

@objc(CDProject)
class CDProject: NSManagedObject {}

/// The Swift representation of the CoreData (CD)Project.
struct Project: CDRepresentable {

    let cd: CDProject
    init(_ cd: CDProject) { self.cd = cd }
    
    func willChange() {
        cd.objectWillChange.send()
        items.forEach { $0.cd.objectWillChange.send() }
    }
    
}

extension Project {
    
    var items: [Item] {
        get {
            let cdItems = cd.items?.allObjects as? [Item.CD] ?? []
            return cdItems.map(Item.init)
        }
        set {
            let cdItems = newValue.map(\.cd)
            cd.items = NSSet(array: cdItems)
        }
    }

    var title: String? {
        get { cd.title }
        set { cd.title = newValue }
    }

    var details: String {
        get { cd.details ?? "" }
        set { cd.details = newValue }
    }

    var colorID: ColorID {
        get { ColorID(rawValue: cd.color ?? "Light Blue") ?? .lightBlue }
        set { cd.color = newValue.rawValue }
    }

    var closed: Bool {
        get { cd.closed }
        set { cd.closed = newValue }
    }
    
    var reminder: Date? {
        get {
            if let reminder = cd.reminder, reminder > Date.now {
                return reminder
            } else { return nil }
        }
        set {
            if let reminder = newValue, reminder > Date.now {
                cd.reminder = reminder
            } else { cd.reminder = nil }
        }
    }

    var timestamp: Date { cd.timestamp ?? Date() }

    var progress: Double {
        guard !items.isEmpty else { return 0 }

        let completed = items.filter(\.completed)
        return Double(completed.count) / Double(items.count)
    }

    init(
        in context: NSManagedObjectContext,
        title: String? = nil,
        details: String = "",
        colorID: ColorID = .lightBlue
    ) {
        cd = CDProject(context: context)

        cd.timestamp = Date()
        self.closed = false

        self.title = title
        self.details = details
        self.colorID = colorID
    }

}

extension Project: Identifiable { var id: ObjectIdentifier { cd.id } }

enum ColorID: String, CaseIterable, Codable {
    
    case pink = "Pink", purple = "Purple", red = "Red",
         orange = "Orange", gold = "Gold", green = "Green",
         teal = "Teal", lightBlue = "Light Blue", darkBlue = "Dark Blue",
         midnight = "Midnight", darkGray = "Dark Gray", gray = "Gray"
    
}
