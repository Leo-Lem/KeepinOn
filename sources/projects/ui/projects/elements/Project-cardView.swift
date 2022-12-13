//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension Project {
  func cardView() -> some View { Project.CardView(self) }

  struct CardView: View {
    let project: Project

    var body: some View {
      VStack(alignment: .leading) {
        Text("ITEMS \(project.items.count)")
          .font(.default(.caption1))
          .foregroundColor(.secondary)

        Text(project.label)
          .font(.default(.title2))
          .foregroundColor(project.color)

        ProgressView(value: items.progress)
          .tint(project.color)
      }
      .padding()
      .background(Config.style.background)
      .cornerRadius(10)
#if os(iOS)
        .shadow(color: project.color, radius: 5)
#endif
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.a11y(items))
        .accessibilityValue(project.label)
        .animation(.default, value: items)
        .task {
          await projectsController.loadItems(of: project, into: itemsBinding)
          tasks["updateItems"] = projectsController.databaseService.handleEventsTask(.background) { event in
            await projectsController.updateItems(of: project, on: event, into: itemsBinding)
          }
        }
        .onChange(of: project) { newProject in
          Task(priority: .userInitiated) { await projectsController.loadItems(of: newProject, into: itemsBinding) }
        }
    }

    @Persisted var items: [Item]
    private var itemsBinding: Binding<[Item]> { Binding(get: { items }, set: { items = $0 }) }

    @EnvironmentObject var projectsController: ProjectsController
    
    private let tasks = Tasks()

    init(_ project: Project) {
      self.project = project
      _items = Persisted(wrappedValue: [], "\(project.id)-items")
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectCard_Previews: PreviewProvider {
  static var previews: some View {
    Project.example.cardView()
      
  }
}
#endif
