//	Created by Leopold Lemmermann on 07.11.22.

import SwiftUI

struct ItemListView: View {
  let projectWithItems: Project.WithItems,
      editingEnabled: Bool,
      add: () -> Void,
      toggleIsDone: (Item) -> Void,
      edit: (Item) -> Void,
      delete: (Item) -> Void

  @ViewBuilder var body: some View {
    ForEach(projectWithItems.items) { item in
      SheetLink(.item(item, projectWithItems: projectWithItems)) {
        Item.Row(Item.WithProject(item, project: projectWithItems.project))
      }
      .if(editingEnabled) { $0
        .addItemSwipeActions(
          item,
          toggleIsDone: toggleIsDone,
          edit: edit,
          delete: delete
        )
      }
      .transition(.slide)
    }

    if editingEnabled {
      Button(action: add, label: { Label("ADD_ITEM", systemImage: "plus") })
    }
  }

  init(
    _ projectWithItems: Project.WithItems,
    editingEnabled: Bool,
    add: @escaping () -> Void,
    toggleIsDone: @escaping (Item) -> Void,
    edit: @escaping (Item) -> Void,
    delete: @escaping (Item) -> Void
  ) {
    self.projectWithItems = projectWithItems
    self.editingEnabled = editingEnabled
    self.add = add
    self.toggleIsDone = toggleIsDone
    self.edit = edit
    self.delete = delete
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
      Form {
        ItemListView(
          Project.WithItems.example,
          editingEnabled: true,
          add: {},
          toggleIsDone: { _ in },
          edit: { _ in },
          delete: { _ in }
        )
      }
      .configureForPreviews()
    }
  }
#endif
