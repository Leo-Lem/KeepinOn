//  Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

struct EditItemView: View {
  var body: some View {
    NavigationStack {
      Form {
        Section("GENERIC_SETTINGS") {
          TextField("ITEM_NAME_PLACEHOLDER", text: $vm.title)
          TextField("ITEM_DESCRIPTION_PLACEHOLDER", text: $vm.details)
        }

        Section("PRIORITY") {
          Picker("PRIORITY", selection: $vm.priority, items: Item.Priority.allCases, id: \.self) { priority in
            Text(priority.label)
              .tag(priority)
          }
          .pickerStyle(.segmented)
        }
        Section {
          Toggle("MARK_COMPLETED", isOn: Binding<Bool>(get: { vm.isDone }, set: { vm.setIsDone($0) }))
        }
      }
      .styledNavigationTitle("EDIT_ITEM")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("GENERIC_SAVE") { vm.updateItem() }
            .buttonStyle(.borderedProminent)
        }
      }
      .preferred(style: SheetViewStyle(size: .fraction(0.7)))
    }
  }

  @StateObject private var vm: ViewModel

  init(_ item: Item, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(item: item, appState: appState))
  }
}

// MARK: - (Previews)

struct EditItemView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      EditItemView(.example, appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview {
        EditItemView(.example, appState: .example)
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
