//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import Errors
import LeosMisc
import Previews
import SwiftUI

extension Project {
  func detailView() -> some View { Project.DetailView(self) }

  struct DetailView: View {
    let project: Project

    var body: some View {
      VStack {
        HStack {
          Text(project.label)
            .font(.default(.largeTitle))
            .fontWeight(.heavy)

          project.statusIcon()
            .labelStyle(.iconOnly)
            .font(.default(.title1))
            .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(project.color)
        .accessibilityAddTraits(.isHeader)
        .accessibilityIdentifier("project-detail-page-header")

        Text("\"\(project.detailsLabel)\"")
          .font(.default(.title2))
          .fontWeight(.medium)

        ProgressView(value: items.progress)
          .tint(project.color)
          .padding()

        ScrollView {
          ForEach(items, content: Item.CardView.init)
            .padding()
        }

        Spacer()

        Text("CREATED_ON \(project.timestamp.formatted(date: .abbreviated, time: .shortened))")
          .padding()
          .font(.default(.subheadline))
      }
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
      #if os(iOS)
      .compactDismissButton()
      #endif
    }

    @Persisted var items: [Item]
    private var itemsBinding: Binding<[Item]> { Binding(get: { items }, set: { items = $0 }) }
    
    private let tasks = Tasks()

    @EnvironmentObject var projectsController: ProjectsController

    init(_ project: Project) {
      self.project = project
      _items = Persisted(wrappedValue: [], "\(project.id)-items")
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectDetails_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Project.DetailView(.example)
        .previewDisplayName("Bare")

      Project.example.detailView()
        .previewInSheet()
        .previewDisplayName("Sheet")
    }
    
  }
}
#endif
