//  Created by Leopold Lemmermann on 09.10.2022.

import InAppPurchaseService
import SwiftUI

struct ProjectsView: View {
  @EnvironmentObject private var state: MainState
  @Environment(\.dismiss) private var dismiss
  let closed: Bool

  var body: some View {
    Content(vm: ViewModel(closed: closed, dismiss: dismiss.callAsFunction, mainState: state))
  }

  struct Content: View {
    @StateObject var vm: ViewModel

    var body: some View {
      List(vm.projects) { project in
        let canEdit = !vm.closed
        Section {
          let items = vm.items[project.id]?.sorted(using: vm.itemSortOrder) ?? []
          items.listView(canEdit: canEdit)

          if canEdit {
            Button { vm.addItem(to: project) } label: { Label("ADD_ITEM", systemImage: "plus") }
              .buttonStyle(.borderless)
          }
        } header: {
          Project.HeaderView(project, canEdit: canEdit)
        }
      }
      .replace(if: vm.projects.count <= 0, placeholder: "NO_PROJECTS_PLACEHOLDER")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Config.style.background)
      .scrollContentBackground(.hidden)
      .toolbar {
        if !vm.closed { addProjectButton }
        $vm.itemSortOrder.selectionMenu
      }
      .sheet(isPresented: $vm.isPurchasing) { PurchaseID.fullVersion.view(service: vm.purchaseService) }
      .animation(.default, value: vm.projects)
      .animation(.default, value: vm.items)
    }
  }
}

private extension ProjectsView.Content {
  var addProjectButton: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button { vm.addProject() } label: {
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
        NavigationStack { ProjectsView(closed: false) }
          .previewDisplayName("Open")

        NavigationStack { ProjectsView(closed: true) }
          .previewDisplayName("Closed")
      }
      .configureForPreviews()
    }
  }
#endif
