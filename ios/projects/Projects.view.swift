//  Created by Leopold Lemmermann on 09.10.2022.

import SwiftUI

struct ProjectsView: View {
  var body: some View {
    List(vm.projects) { project in
      Section {
        ItemListView(
          items: project.items.sorted(using: vm.sortOrder),
          editingEnabled: !vm.closed,
          add: { vm.addItem(to: project) },
          toggleIsDone: { item in vm.toggleIsDone(for: item) },
          edit: { item in vm.startEditing(item: item) },
          delete: { item in vm.delete(item: item) }
        )
      } header: {
        ProjectHeader(
          project,
          editingEnabled: !vm.closed,
          toggleIsClosed: { project in vm.toggleIsClosed(for: project) },
          delete: { project in await vm.delete(project: project) }
        )
      }
    }
    // styling
    .replace(if: vm.projects.count < 1) {
      Text("NO_PROJECTS_PLACEHOLDER")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(config.style.background)
    .scrollContentBackground(.hidden)
    .styledNavigationTitle(vm.closed ? "CLOSED_TITLE" : "OPEN_TITLE")
    .toolbar {
      if !vm.closed { addProjectButton }
      SortOrderMenu(sortOrder: $vm.sortOrder)
    }
    .animation(.default, value: vm.projects)
  }

  @StateObject private var vm: ViewModel

  init(closed: Bool, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(closed: closed, appState: appState))
  }

  var addProjectButton: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        vm.addProject()
      } label: {
        Label("ADD_PROJECT", systemImage: "plus")
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationStack { ProjectsView(closed: false, appState: .example) }
        .previewDisplayName("Open")

      NavigationStack { ProjectsView(closed: true, appState: .example) }
        .previewDisplayName("Closed")
    }
    .configureForPreviews()
  }
}
#endif
