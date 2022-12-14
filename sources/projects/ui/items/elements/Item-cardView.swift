//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI
import DatabaseService

extension Item {
  func cardView() -> some View { CardView(self) }
  
  struct CardView: View {
    let item: Item
    
    var body: some View {
      HStack(spacing: 20) {
        Image(systemName: item.icon)
          .font(.default(.title1))
          .imageScale(.large)
          .foregroundColor(project?.color)
          .accessibilityLabel(item.a11y)
        
        VStack(alignment: .leading) {
          Text(item.label)
            .font(.default(.title2))
            .foregroundColor(.primary)
          
          if !item.details.isEmpty {
            Text(item.details)
              .foregroundColor(.secondary)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background(Config.style.background)
      .cornerRadius(10)
      #if os(iOS)
        .shadow(color: project?.color ?? .primary, radius: 2)
      #endif
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(item.a11y)
        .accessibilityValue(item.label)
        .animation(.default, value: project)
        .task {
          await projectsController.loadProject(of: item, into: projectBinding)
          tasks["updateProject"] = projectsController.databaseService.handleEventsTask(.background) { event in
            await projectsController.updateProject(of: item, on: event, into: projectBinding)
          }
        }
        .onChange(of: item) { newItem in
          Task(priority: .userInitiated) { await projectsController.loadProject(of: newItem, into: projectBinding) }
        }
    }
    
    @Persisted var project: Project?
    private var projectBinding: Binding<Project?> { Binding(get: { project }, set: { project = $0 }) }
    
    @EnvironmentObject private var projectsController: ProjectsController
    
    private let tasks = Tasks()
    
    init(_ item: Item) {
      self.item = item
      _project = Persisted(wrappedValue: nil, "\(item)-project")
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemCard_Previews: PreviewProvider {
  static var previews: some View {
    Item.example.cardView()
      .previewDisplayName("Simple")
      
  }
}
#endif
