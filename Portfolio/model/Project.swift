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
    
    init?(_ cd: CDProject?) {
        if let cd = cd { self.cd = cd  } else { return nil }
    }
    
    func update() {
        cd.objectWillChange.send()
        items.forEach { $0.cd.objectWillChange.send() }
    }
    
}

extension Project {
    
    var items: [Item] {
        get {
            let cdItems = cd.items?.allObjects as? [CDItem] ?? []
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
