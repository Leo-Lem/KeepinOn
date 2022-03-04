//
//  HomeView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @FetchRequest(fetchRequest: projectRequest) var cdProjects: FetchedResults<Project.CDObject>
    @FetchRequest(fetchRequest: itemRequest) var cdItems: FetchedResults<Item.CDObject>
    
    var body: some View {
        Content(
            projects: cdProjects.map(Project.init),
            items: cdItems.map(Item.init)
        ) }
    
    @EnvironmentObject var dataController: DataController

    static let projectRequest: NSFetchRequest<Project.CDObject> = {
        let request: NSFetchRequest<Project.CDObject> = Project.CDObject.fetchRequest()
        
        request.predicate = NSPredicate(format: "closed = false")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.CDObject.title, ascending: true)]
            
        return request
    }()
    
    static let itemRequest: NSFetchRequest<Item.CDObject> = {
        let request: NSFetchRequest<Item.CDObject> = Item.CDObject.fetchRequest()
        
        let completedPredicate = NSPredicate(format: "completed = false"),
            openPredicate = NSPredicate(format: "project.closed = false")
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.CDObject.priority, ascending: false)]
        request.fetchLimit = 10
        
        return request
    }()
    
}
