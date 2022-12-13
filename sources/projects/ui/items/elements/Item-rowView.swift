//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI

extension Item {
  func rowView() -> some View { RowView(self) }

  struct RowView: View {
    let item: Item

    var body: some View {
      Label(title: Text(item.label).fixedSize) {
        Image(systemName: item.icon)
          .foregroundColor(project?.color)
      }
      .font(.default())
      .accessibilityLabel(item.a11y)
      .accessibilityValue(item.label)
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
    
    @EnvironmentObject private var projectsController: ProjectsController
    
    private let tasks = Tasks()

    init(_ item: Item) {
      self.item = item
      _project = Persisted(wrappedValue: nil, "\(item)-project")
    }
  }
}

// MARK: - (Previews)

#if DEBUG
struct ItemRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Item.example.rowView()

      List {
        ForEach([Item.example, .example, .example], content: Item.RowView.init)
      }
      .previewDisplayName("List")
    }
    
  }
}
#endif
