//  Created by Leopold Lemmermann on 09.10.22.

import Errors
import LeosMisc
import Previews
import SwiftUI

extension Item {
  func editingView() -> some View { EditingView(self) }

  struct EditingView: View {
    var body: some View {
      Form {
        Section("SETTINGS") {
          TextField("ITEM_NAME_PLACEHOLDER", text: $item.title)
            .accessibilityIdentifier("edit-item-name")
          
          TextField("ITEM_DESCRIPTION_PLACEHOLDER", text: $item.details)
            .accessibilityIdentifier("edit-item-description")
        }

        Section("PRIORITY") {
          Picker(
            String(localized: "PRIORITY"), selection: $item.priority, items: Item.Priority.allCases, id: \.self
          ) { priority in
            Text(priority.title)
              .tag(priority)
          }
          .pickerStyle(.segmented)
          .labelsHidden()
        }
        
        Section {
          Toggle("MARK_COMPLETED", isOn: Binding { item.isDone } set: { _ in
            Task(priority: .userInitiated) {
              await mainState.toggleItemIsDone(with: item.id)
              item.isDone.toggle()
              #if os(iOS)
              await mainState.updateItem(item)
              dismiss()
              #endif
            }
          })
        }
      }
      .formStyle(.grouped)
      .navigationTitle("EDIT_ITEM")
#if os(iOS)
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
              await mainState.updateItem(item)
              dismiss()
            } label: {
              Label("SAVE", systemImage: "tray.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("save-item")
          }
        }
        .compactDismissButtonToolbar()
        .embedInNavigationStack()
#elseif os(macOS)
        .onChange(of: item) { item in
          Task(priority: .userInitiated) { await mainState.updateItem(item) }
        }
#endif
        .presentationDetents([.fraction(0.7)])
    }

    @State private var item: Item
    @EnvironmentObject private var mainState: MainState
    @Environment(\.dismiss) private var dismiss

    init(_ item: Item) { _item = State(initialValue: item) }
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
