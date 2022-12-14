//	Created by Leopold Lemmermann on 07.11.22.

import ComposableArchitecture
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension Comment {
  func rowView() -> some View { RowView(self) }

  struct RowView: View {
    let comment: Comment

    var body: some View {
      WithViewStore<ViewState, ViewAction, _>(store) { state in
        ViewState(
          poster: state.publicDatabase.users.convertible(with: comment.poster),
          isDeletable: comment.poster == state.account.id,
          canDelete: state.account.canPublish
        )
      } send: { action in
        switch action {
        case .loadPoster: return .publicDatabase(.users(.loadWith(id: comment.poster)))
        case .delete: return .publicDatabase(.comments(.deleteWith(id: comment.id)))
        }
      } content: { vm in
        Render(comment, poster: vm.poster, isDeletable: vm.isDeletable, canDelete: vm.canDelete) {
          await vm.send(.delete).finish()
          // TODO: throw error here
        }
        .task { await vm.send(.loadPoster).finish() }
      }
    }

    @EnvironmentObject private var store: StoreOf<MainReducer>

    init(_ comment: Comment) { self.comment = comment }

    struct ViewState: Equatable { var poster: User?, isDeletable: Bool, canDelete: Bool }
    enum ViewAction { case loadPoster, delete }

    struct Render: View {
      let comment: Comment
      let poster: User?
      let isDeletable: Bool
      let canDelete: Bool
      let delete: () async throws -> Void

      var body: some View {
        HStack(alignment: .top) {
          if size == .regular {
            if let poster {
              poster.peekButton().frame(height: 50)
              poster.nameView()
                .frame(maxWidth: 150, alignment: .leading)
            }
          }

          VStack {
            if size == .compact {
              HStack {
                if let poster {
                  poster.peekButton().frame(height: 50)
                  poster.nameView()
                }

                Spacer()
              }
            }

            Text(comment.content.replacing("\n", with: ""))
              .minimumScaleFactor(0.5)
              .font(.default(.body))
              .multilineTextAlignment(size == .regular ? .leading : .center)
              .frame(maxWidth: .infinity, alignment: size == .regular ? .leading : .center)

            HStack {
              Spacer()

              Text(comment.timestamp.formatted(date: .complete, time: .shortened))
                .font(.default(.caption2))
                .foregroundColor(.gray)
                .padding(.top, 5)

              #if os(macOS)
                if isDeletable { deleteButton() }
              #endif
            }
          }
        }

        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A11Y_COMMENT")
        .accessibilityValue(comment.a11y(posterLabel: poster?.label))
        .if(isDeletable) { $0
          #if os(iOS)
            .swipeActions(edge: .trailing, content: deleteButton)
          #endif
        }
      }

      @State private var error: DatabaseError?
      @Environment(\.size) private var size

      init(_ comment: Comment, poster: User?, isDeletable: Bool, canDelete: Bool, delete: @escaping () async -> Void) {
        (self.comment, self.poster, self.isDeletable, self.canDelete) = (comment, poster, isDeletable, canDelete)
        self.delete = delete
      }

      func deleteButton() -> some View {
        AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
          await printError {
            do {
              try await delete()
            } catch let error as DatabaseError where error.hasDescription { self.error = error }
          }
        } label: {
          Label("DELETE", systemImage: "trash.circle")
        }
        .foregroundColor(.red)
        .labelStyle(.iconOnly)
        .disabled(!canDelete)
        .buttonStyle(.borderless)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct CommentsViewRow_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Comment.RowView.Render(.example, poster: .example, isDeletable: false, canDelete: true) {}

        List { Comment.RowView.Render(.example, poster: .example, isDeletable: true, canDelete: true) {} }
          .previewDisplayName("Deletable")

        List([Comment.example, .example, .example]) { comment in
          Comment.RowView.Render(comment, poster: .example, isDeletable: true, canDelete: true) {}
        }
        .previewDisplayName("List")
      }
      .presentPreview()
    }
  }
#endif
