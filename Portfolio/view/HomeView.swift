//
//  HomeView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(fetchRequest: projectRequest) var projects: FetchedResults<Project>
    @FetchRequest(fetchRequest: itemRequest) var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.fixed(100))]) {
                        ForEach(projects, content: ProjectSummary.init)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                VStack(alignment: .leading) {
                    ItemList(title: ~.nextItems, items: items.prefix(3))
                    ItemList(title: ~.moreItems, items: items.dropFirst(3))
                }
                .padding(.horizontal)
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle(~.home)
        }
    }
}

private extension HomeView {
    
    static let itemRequest: NSFetchRequest<Item> = {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let completedPredicate = NSPredicate(format: "completed = false"),
            openPredicate = NSPredicate(format: "project.closed = false"),
            compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        request.predicate = compoundPredicate
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
        request.fetchLimit = 10
        
        return request
    }()
    
    static let projectRequest: NSFetchRequest<Project> = {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.predicate = NSPredicate(format: "closed = false")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
        
        return request
    }()

}

#if DEBUG
// MARK: - (Previews)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(
                \.managedObjectContext,
                 dataController.container.viewContext
            )
            .environmentObject(dataController)
    }
}
#endif
