//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct HomeView: View {
  var body: some View {
    ScrollView {
      HomeView.ProjectListView(
        vm.projects,
        edit: { project in vm.startEditing(project) },
        show: { project in vm.showInfo(for: project) }
      )

      VStack(alignment: .leading) {
        HomeView.ItemPeekListView(
          "NEXT_ITEMS",
          items: vm.upNext,
          edit: { item in vm.startEditing(item) },
          show: { item in vm.showInfo(for: item) }
        )

        HomeView.ItemPeekListView(
          "MORE_ITEMS",
          items: vm.moreItems,
          edit: { item in vm.startEditing(item) },
          show: { item in vm.showInfo(for: item) }
        )
      }
      .padding(.horizontal)
    }
    .background(config.style.background)
    .styledNavigationTitle("HOME_TITLE")
    #if DEBUG
      .toolbar {
        ToolbarItem(placement: .automatic) {
          HStack {
            Button("Add data") { vm.createSampleData() }
            Button("Delete All") { vm.deleteAll() }
          }
        }
      }
    #endif
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HomeView(appState: .example)
        .previewDisplayName("Bare")

      NavigationStack { HomeView(appState: .example) }
        .previewDisplayName("Navigation")
    }
    .configureForPreviews()
  }
}
