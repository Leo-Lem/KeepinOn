//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import DatabaseService
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
      #if os(iOS)
      .compactDismissButton()
      #endif
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

private extension Project.DetailView {
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
struct ProjectDetails_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Project.DetailView(.example)
        .previewDisplayName("Bare")

      Project.example.detailView()
        .previewInSheet()
        .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
#endif
