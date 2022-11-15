//	Created by Leopold Lemmermann on 24.10.22.

import SwiftUI

struct SharedProjectView: View {
  var body: some View {
    NavigationStack {
      List {
        Section {
          SharedItemsView(state: vm.itemsLoadState)
        }

        Section {
          CommentsView(state: vm.commentsLoadState) { comment in
            vm.user != nil && vm.user?.id == comment.poster
          } delete: { comment in
            await vm.delete(comment)
          }
        } header: {
          Text("COMMENTS_HEADER")
        } footer: {
          PostCommentView(canPostComments: vm.canPostComments) { text in
            try await vm.postComment(text: text)
          } startAuthentication: {
            vm.startAuthentication()
          }
          .padding(.vertical)
        }
      }
      .refreshable { vm.refresh() }
      .styledNavigationTitle(Text(vm.project.label))
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
//          Text("POSTED_BY \(vm.project.owner.label)")
        }
      }
      .animation(.default, value: vm.itemsLoadState)
      .animation(.default, value: vm.commentsLoadState)
    }
  }

  @StateObject private var vm: ViewModel

  init(_ project: Project.Shared, appState: AppState) {
    _vm = StateObject(wrappedValue: ViewModel(project: project, appState: appState))
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedProjectView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SharedProjectView(.example, appState: .example)
        .previewDisplayName("Bare")

      SheetView.Preview {
        SharedProjectView(.example, appState: .example)
      }
      .previewDisplayName("Sheet")
    }
    .configureForPreviews()
  }
}
#endif
