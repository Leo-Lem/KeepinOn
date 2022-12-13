//  Created by Leopold Lemmermann on 07.11.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI

extension Project {
  func itemsListView(canEdit: Bool, selectedDetail: Binding<Detail?>) -> some View {
    ItemsListView(self, canEdit: canEdit, selectedDetail: selectedDetail)
  }

  struct ItemsListView: View {
    @Binding var selectedDetail: Detail?
    let project: Project
    let canEdit: Bool

    var body: some View {
      Group {
        ForEach(items.sorted(using: mainState.sortOrder)) { item in
          Button { selectedDetail = .item(item) } label: { item.rowView() }
            .if(canEdit) { $0
              .itemContextActions(item, isEditing: Binding(item: $selectedDetail, defaultValue: .editItem(item)))
            }
        }

        if canEdit {
          AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { await addItem() } label: {
            Label("ADD_ITEM", systemImage: "plus.circle")
          }
          .accessibilityIdentifier("add-item")
          .popover(isPresented: $isPurchasing) { InAppPurchaseView(.fullVersion) }
        }
      }
      .task {
        await loadItems(of: project)
        tasks["updateItems"] = Task(priority: .background) { await updateItems() }
      }
      .onChange(of: project) { newProject in
        Task(priority: .userInitiated) { await loadItems(of: newProject) }
      }
    }

    @State var isPurchasing = false
    @Persisted var items: [Item]
    @State private var tasks = Tasks()
    @EnvironmentObject var mainState: MainState

    init(_ project: Project, canEdit: Bool, selectedDetail: Binding<Detail?>) {
      self.project = project
      self.canEdit = canEdit
      _selectedDetail = selectedDetail
      _items = Persisted(wrappedValue: [], "\(project.id)-items")
    }

    @MainActor func addItem() async {
      await printError {
        guard mainState.hasFullVersion || items.count < Config.freeLimits.items else { return isPurchasing = true }

        let item = Item(project: project.id)
        try await mainState.privateDBService.insert(item)
        try await mainState.privateDBService.modify(Project.self, with: project.id) { editable in
          editable.items.append(item.id)
        }

        try await mainState.awardsService.addedItem()
      }
    }
  }
}

private extension Project.ItemsListView {
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
struct ItemsListView_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Detail?.none) { binding in
      Form { Project.ItemsListView(.example, canEdit: false, selectedDetail: binding) }
        .previewDisplayName("Without editing")

      Form { Project.example.itemsListView(canEdit: true, selectedDetail: binding) }
        .previewDisplayName("With editing")
    }
    .configureForPreviews()
  }
}
#endif
