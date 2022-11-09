//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct HomeView: View {
  var body: some View {
    ScrollView {
      HomeView.ProjectListView(
        vm.projectsWithItems,
        edit: { project in vm.startEditing(project) },
        show: { projectWithItems in vm.showInfo(for: projectWithItems) }
      )

      VStack(alignment: .leading) {
        HomeView.ItemPeekListView(
          "NEXT_ITEMS",
          itemsWithProject: vm.upNext,
          edit: { item in vm.startEditing(item) },
          show: { itemWithProject in vm.showInfo(for: itemWithProject) }
        )

        HomeView.ItemPeekListView(
          "MORE_ITEMS",
          itemsWithProject: vm.moreItems,
          edit: { item in vm.startEditing(item) },
          show: { itemWithProject in vm.showInfo(for: itemWithProject) }
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
            Button("Add data") { vm.privDBService.createSampleData() }
            Button("Delete All") { vm.privDBService.deleteAll() }
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

#if DEBUG
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
#endif
