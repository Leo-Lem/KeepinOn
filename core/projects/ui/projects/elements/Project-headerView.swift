//	Created by Leopold Lemmermann on 09.10.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension Project {
  func headerView(canEdit: Bool, selectedDetail: Binding<Detail?>) -> some View {
    HeaderView(self, canEdit: canEdit, selectedDetail: selectedDetail)
  }

  struct HeaderView: View {
    @Binding var selectedDetail: Detail?
    let project: Project
    let canEdit: Bool

    var body: some View {
      HStack {
        #if os(iOS)
        VStack(alignment: .leading) {
          HStack {
            Text(project.label).lineLimit(1)
            AsyncButton { selectedDetail = .project(project) } label: {
              Label("SHOW_PROJECT_DETAILS", systemImage: "info.bubble")
            }
          }
          ProgressView(value: items.progress)
        }
        #elseif os(macOS)
        Button { selectedDetail = .project(project) } label: {
          Text(project.label).lineLimit(1)
          Spacer()
        }
        .buttonStyle(.borderless)
        .font(.default(.headline))
        #endif

        Spacer()

        project.toggleButton()

        if canEdit {
          AsyncButton { selectedDetail = .editProject(project) } label: {
            Label("EDIT_PROJECT", systemImage: "square.and.pencil")
          }
          .tint(.yellow)
          project.deleteButton()
        }
      }
      .labelStyle(.iconOnly)
      .tint(project.color)
      .padding(.bottom, 10)
      .accessibilityElement(children: .contain)
      .accessibilityLabel(project.a11y(items))
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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var mainState: MainState

    init(_ project: Project, canEdit: Bool, selectedDetail: Binding<Detail?>) {
      self.project = project
      self.canEdit = canEdit
      _selectedDetail = selectedDetail
      _items = Persisted(wrappedValue: [], "\(project.id)-items")
    }
  }
}

private extension Project.HeaderView {
  @MainActor func loadItems(of project: Project) async {
    await printError {
      items.removeAll { item in !project.items.contains(where: { $0 == item.id }) }

      for item: Item in try await project.items.compactMap({ try await mainState.fetch(with: $0) }) {
        mainState.insert(item, into: &items)
      }
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
          if let id = id as? Item.ID {
            mainState.remove(with: id, from: &items)
          }
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
struct ProjectHeader_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Detail?.none) { binding in
      Form {
        Section {
          Text("some content (can edit)")
        } header: {
          Project.HeaderView(.example, canEdit: true, selectedDetail: binding)
        }

        Section {
          Text("some more content (cannot edit)")
        } header: {
          Project.example.headerView(canEdit: false, selectedDetail: binding)
        }
      }
    }
    .configureForPreviews()
  }
}
#endif
