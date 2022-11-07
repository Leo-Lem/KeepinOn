//	Created by Leopold Lemmermann on 07.10.22.

import SwiftUI

struct CommunityView: View {
  var body: some View {
    List {
      switch vm.loadState {
      case let .loading(projects):
        SharedProjectsList(projects, user: vm.user)
      case let .loaded(projects):
        SharedProjectsList(projects, user: vm.user)
      #if DEBUG
        case let .failed(error):
          Text(error?.localizedDescription ?? "")
      #endif
      default:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .refreshable { vm.refresh() }
    .background(config.style.background)
    .styledNavigationTitle("COMMUNITY_TITLE")
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        SheetLink(.account) { Image(systemName: "person.crop.circle") }
      }
      if case .loading = vm.loadState {
        ToolbarItem(placement: .navigationBarTrailing) { ProgressView() }
      }
      #if DEBUG
        ToolbarItem(placement: .automatic) {
          HStack {
            Button("Add data") { vm.createSampleData() }
            Button("Delete All") { vm.deleteAll() }
          }
        }
      #endif
    }
  }

  @StateObject private var vm: ViewModel

  init(appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(appState: appState))
  }
}

// MARK: - (PREVIEWS)

struct CommunityView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CommunityView(appState: .example)
        .previewDisplayName("Bare")

      NavigationStack { CommunityView(appState: .example) }
        .previewDisplayName("Navigation")
    }
    .configureForPreviews()
  }
}
