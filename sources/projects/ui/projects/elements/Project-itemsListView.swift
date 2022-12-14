//  Created by Leopold Lemmermann on 07.11.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI
import AwardsController
import DatabaseService

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
        ForEach(items.sorted(using: projectsController.sortOrder)) { item in
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
        await projectsController.loadItems(of: project, into: itemsBinding)
        tasks["updateItems"] = projectsController.databaseService.handleEventsTask(.background) { event in
          await projectsController.updateItems(of: project, on: event, into: itemsBinding)
        }
      }
      .onChange(of: project) { newProject in
        Task(priority: .userInitiated) { await projectsController.loadItems(of: newProject, into: itemsBinding) }
      }
    }

    @State var isPurchasing = false
    @Persisted var items: [Item]
    private var itemsBinding: Binding<[Item]> { Binding(get: { items }, set: { items = $0 }) }
    
    private let tasks = Tasks()
    
    @EnvironmentObject private var projectsController: ProjectsController
    @EnvironmentObject private var awardsController: AwardsController
    @EnvironmentObject private var iapController: IAPController

    init(_ project: Project, canEdit: Bool, selectedDetail: Binding<Detail?>) {
      self.project = project
      self.canEdit = canEdit
      _selectedDetail = selectedDetail
      _items = Persisted(wrappedValue: [], "\(project.id)-items")
    }

    @MainActor func addItem() async {
      await printError {
        guard iapController.fullVersionIsUnlocked || project.items.count <= Config.freeLimits.items else {
          return isPurchasing = true
        }

        let item = Item(project: project.id)
        try await projectsController.databaseService.insert(item)
        try await projectsController.databaseService.modify(Project.self, with: project.id) { editable in
          editable.items.append(item.id)
        }

        try await awardsController.addedItem()
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
    
  }
}
#endif
