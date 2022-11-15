//  Created by Leopold Lemmermann on 09.10.2022.

import SwiftUI

struct ProjectsView: View {
  var body: some View {
    List(vm.projectsWithItems) { projectWithItems in
      Section {
        ItemListView(
          projectWithItems,
          editingEnabled: !vm.closed,
          add: { vm.addItem(to: projectWithItems.project) },
          toggleIsDone: { item in vm.toggleIsDone(for: item) },
          edit: { item in vm.startEditing(item: item) },
          delete: { item in vm.delete(item: item) }
        )
      } header: {
        ProjectHeader(
          projectWithItems,
          editingEnabled: !vm.closed,
          toggleIsClosed: { project in vm.toggleIsClosed(for: project) },
          delete: { project in await vm.delete(project: project) }
        )
      }
    }
    .replace(if: vm.projectsWithItems.count <= 0) {
      Text("NO_PROJECTS_PLACEHOLDER")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(config.style.background)
    .scrollContentBackground(.hidden)
    .styledNavigationTitle(vm.closed ? "CLOSED_TITLE" : "OPEN_TITLE")
    .toolbar {
      if !vm.closed {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            vm.addProject()
          } label: {
            Label("ADD_PROJECT", systemImage: "plus")
          }
        }
      }
      $vm.sortOrder.selectionMenu
    }
    .animation(.default, value: vm.projectsWithItems)
  }

  @StateObject private var vm: ViewModel

  init(closed: Bool, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(closed: closed, appState: appState))
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