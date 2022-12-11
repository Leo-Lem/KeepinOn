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
        await loadProject()
        tasks["updateProject"] = Task(priority: .background) { await updateProject() }
      }
    }

    @Persisted private var project: Project?
    @State private var tasks = Tasks()
    @EnvironmentObject private var mainState: MainState

    init(_ item: Item) {
      self.item = item
      _project = Persisted(wrappedValue: nil, "\(item)-project")
    }
  }
}

private extension Item.RowView {
  @MainActor func loadProject() async {
    await printError {
      project = try await mainState.privateDBService.fetch(with: item.project)
    }
  }

  @MainActor func updateProject() async {
    await printError {
      for await event in mainState.privateDBService.events {
        switch event {
        case let .inserted(type, id):
          switch (type, id) {
          case (is Project.Type, let id as Project.ID) where id == item.project:
            if let project: Project = try await mainState.privateDBService.fetch(with: id) { self.project = project }
          default: break
          }
        case let .deleted(type, id):
          switch (type, id) {
          case (is Project.Type, let id as Project.ID) where id == item.project: project = nil
          default: break
          }
        case .remote: await loadProject()
        default: break
        }
      }
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
    .configureForPreviews()
  }
}
#endif
