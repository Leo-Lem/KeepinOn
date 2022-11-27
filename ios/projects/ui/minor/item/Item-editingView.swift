//  Created by Leopold Lemmermann on 09.10.22.

import Errors
import Previews
import SwiftUI

extension Item {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    let item: Item

    var body: some View {
      NavigationStack {
        Form {
          Section("GENERIC_SETTINGS") {
            TextField("ITEM_NAME_PLACEHOLDER", text: $title)
            TextField("ITEM_DESCRIPTION_PLACEHOLDER", text: $details)
          }

          Section("PRIORITY") {
            Picker("PRIORITY", selection: $priority, items: Item.Priority.allCases, id: \.self) { priority in
              Text(priority.label)
                .tag(priority)
            }
            .pickerStyle(.segmented)
          }
          Section {
            Toggle("MARK_COMPLETED", isOn: Binding<Bool>(get: { isDone }, set: setIsDone))
          }
        }
        .navigationTitle("EDIT_ITEM")
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button("GENERIC_SAVE") { updateItem() }
              .buttonStyle(.borderedProminent)
          }
          
          if vSize == .compact {
            ToolbarItem(placement: .cancellationAction) {
              Button("GENERIC_CANCEL") { dismiss() }
                .buttonStyle(.borderedProminent)
            }
          }
        }
      }
      .presentationDetents([.fraction(0.7)])
    }

    @EnvironmentObject private var mainState: MainState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.verticalSizeClass) var vSize

    @State private var title: String
    @State private var details: String
    @State private var priority: Item.Priority
    @State private var isDone: Bool

    init(_ item: Item) {
      self.item = item

      _title = State(initialValue: item.title)
      _details = State(initialValue: item.details)
      _isDone = State(initialValue: item.isDone)
      _priority = State(initialValue: item.priority)
    }
  }
}

private extension Item.EditingView {
  func setIsDone(_ new: Bool) {
    isDone = new

    updateItem()

    if new {
      Task(priority: .userInitiated) {
        await printError {
          try await mainState.awardsService.completedItem()
        }
      }
    }
  }

  func updateItem() {
    var item = item
    item.title = title
    item.details = details
    item.isDone = isDone
    item.priority = priority

    printError {
      try mainState.localDBService.insert(item)
    }

    dismiss()
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Item.EditingView(.example)
          .previewDisplayName("Bare")

        Item.example.editingView()
          .previewInSheet()
          .previewDisplayName("Sheet")
      }
      .configureForPreviews()
    }
  }
#endif
