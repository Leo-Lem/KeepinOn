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
                        ForEach(projects) { project in
                            VStack(alignment: .leading) {
                                Text("\(project.projectItems.count) items")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text(project.projectTitle)
                                    .font(.title2)

                                ProgressView(value: project.completionAmount)
                                    .tint(Color(project.projectColor))
                            }
                            .padding()
                            .background(Color.secondarySystemGroupedBackground)
                            .cornerRadius(10)
                            .shadow(color: .primary.opacity(0.2), radius: 5)
                            .padding([.horizontal, .top])
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                VStack(alignment: .leading) {
                    list("Up next", for: items.prefix(3))
                    list("More to explore", for: items.dropFirst(3))
                }
                .padding(.horizontal)
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
    
    @ViewBuilder private func list(_ title: String, for items: FetchedResults<Item>.SubSequence) -> some View {
        if !items.isEmpty {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            ForEach(items) { item in
                NavigationLink {
                    EditItemView(item)
                } label: {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text(item.itemTitle)
                                .font(.title2)
                                .foregroundColor(.primary)

                            if !item.itemDetails.isEmpty {
                                Text(item.itemDetails)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: .primary.opacity(0.2), radius: 5)
                }
            }
        }
    }
    
}

private extension HomeView {
    static let itemRequest: NSFetchRequest<Item> = {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")
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
//MARK: - Previews
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
