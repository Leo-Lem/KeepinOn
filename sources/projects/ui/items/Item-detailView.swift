//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc
import Previews
import SwiftUI

extension Item {
  func detailView() -> some View { DetailView(self) }

  struct DetailView: View {
    let item: Item

    var body: some View {
      VStack {
        HStack {
          item.priority.icon
            .font(.default(.headline))
            .bold()

          Text(item.label)
            .font(.default(.largeTitle))
            .fontWeight(.heavy)

          Image(systemName: item.isDone ? "checkmark.circle" : "circle")
            .font(.default(.title1))
            .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(project?.color)
        .accessibilityAddTraits(.isHeader)
        .accessibilityIdentifier("item-detail-page-header")

        Text("\"\(item.detailsLabel)\"")
          .font(.default(.title2))
          .fontWeight(.medium)

        project?.cardView()
          .padding()

        Spacer()

        Text("CREATED_ON \(item.timestamp.formatted(date: .abbreviated, time: .shortened))")
          .padding()
          .font(.default(.subheadline))
      }
      #if os(iOS)
      .compactDismissButton()
      #endif
      .presentationDetents([.medium])
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

    @Persisted private var project: Project?
    private var projectBinding: Binding<Project?> { Binding(get: { project }, set: { project = $0 }) }

    private let tasks = Tasks()

    @EnvironmentObject private var projectsController: ProjectsController

    init(_ item: Item) {
      self.item = item
      _project = Persisted(wrappedValue: nil, "\(item)-project")
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemDetails_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Item.DetailView(.example)
        .previewDisplayName("Bare")

      Item.example.detailView()
        .previewInSheet()
        .previewDisplayName("Sheet")
    }
    
  }
}
#endif
