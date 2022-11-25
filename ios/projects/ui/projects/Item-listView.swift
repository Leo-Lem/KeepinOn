//	Created by Leopold Lemmermann on 07.11.22.

import Errors
import LocalDatabaseService
import RemoteDatabaseService
import SwiftUI

extension Array where Element == Item {
  func listView(canEdit: Bool) -> some View { ListView(self, canEdit: canEdit) }

  struct ListView: View {
    let items: [Item],
        canEdit: Bool

    @ViewBuilder var body: some View {
      ForEach(items) { item in
        Group {
          Button { showInfo(for: item) } label: { item.rowView() }
        }
        .transition(.slide)
        .if(canEdit) { $0
          .swipeActions(edge: .leading) {
            Button { toggleIsDone(item) } label: {
              item.isDone ?
                Label("UNCOMPLETE_ITEM", systemImage: "checkmark.circle.badge.xmark") :
                Label("COMPLETE_ITEM", systemImage: "checkmark.circle")
            }
            .tint(.green)
          }
          .swipeActions(edge: .trailing) {
            Button { delete(item) } label: {
              Label("GENERIC_DELETE", systemImage: "trash")
            }
            .tint(.red)

            Button { startEditing(item) } label: {
              Label("GENERIC_EDIT", systemImage: "square.and.pencil")
            }
            .tint(.yellow)
          }
        }
      }
    }

    @EnvironmentObject private var mainState: MainState

    init(_ items: [Item], canEdit: Bool) {
      self.items = items
      self.canEdit = canEdit
    }
  }
}

private extension Array<Item>.ListView {
  func showInfo(for item: Item) {
    mainState.didChange.send(.sheet(.item(item)))
  }

  func delete(_ item: Item) {
    Task(priority: .userInitiated) {
      await printError {
        if (try? await mainState.remoteDBService.exists(with: item.id, SharedItem.self)) ?? false {
          try await mainState.displayError {
            try await mainState.remoteDBService.unpublish(with: item.id, SharedItem.self)
          }
        }

        try mainState.localDBService.delete(item)
      }
    }
  }

  func startEditing(_ item: Item) {
    mainState.didChange.send(.sheet(.editItem(item)))
  }

  func toggleIsDone(_ item: Item) {
    printError {
      var item = item
      item.isDone.toggle()
      try mainState.localDBService.insert(item)

      if item.isDone {
        Task(priority: .userInitiated) {
          await printError {
            try await mainState.awardsService.completedItem()
          }
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Form {
          [Item].ListView([.example, .example, .example], canEdit: false)
        }
        .previewDisplayName("Without editing")

        Form {
          [Item.example, .example, .example].listView(canEdit: true)
        }
        .previewDisplayName("With editing")
      }
      .configureForPreviews()
    }
  }
#endif
