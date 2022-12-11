//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
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
          await loadItems(of: project)
          tasks["updateItems"] = Task(priority: .background) { await updateItems() }
        }
        .onChange(of: project) { newProject in
          Task(priority: .userInitiated) { await loadItems(of: newProject) }
        }
    }

    @Persisted var items: [Item]
    @State private var tasks = Tasks()
    @EnvironmentObject var mainState: MainState

    init(_ project: Project) {
      self.project = project
      _items = Persisted(wrappedValue: [], "\(project.id)-items")
    }
  }
}

private extension Project.CardView {
  @MainActor func loadItems(of project: Project) async {
    await printError {
      items = try await project.items.compactMap { try await mainState.fetch(with: $0) }
    }
  }

  @MainActor func updateItems() async {
    await printError {
      for await event in mainState.privateDBService.events {
        switch event {
        case let .inserted(type, id) where type == Item.self:
          if
            let id = id as? Item.ID,
            let item: Item = try await mainState.fetch(with: id),
            item.project == project.id
          {
            mainState.insert(item, into: &items)
          }
        case let .deleted(type, id) where type == Item.self:
          if let id = id as? Item.ID { mainState.remove(with: id, from: &items) }
        case .remote:
          await loadItems(of: project)
        default:
          break
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectCard_Previews: PreviewProvider {
  static var previews: some View {
    Project.example.cardView()
      .configureForPreviews()
  }
}
#endif
