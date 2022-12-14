//	Created by Leopold Lemmermann on 22.11.22.

import SwiftUI

extension SharedItem {
  func rowView() -> some View { RowView(self) }

  struct RowView: View {
    let item: SharedItem

    var body: some View {
      WithConvertibleViewStore(
        with: item.project,
        from: \.publicDatabase.projects,
        loadWith: .init { MainReducer.Action.publicDatabase(.projects($0)) }
      ) { project in
        Render(item, project: project)
      }
    }

    init(_ item: SharedItem) { self.item = item }

    struct Render: View {
      let item: SharedItem
      let project: SharedProject?

      var body: some View {
        HStack {
          Image(systemName: item.isDone ? "checkmark.circle" : "circle")
            .foregroundColor(project?.color)

          Text(item.label)

          Text(item.details)
            .lineLimit(1)
            .foregroundColor(.secondary)
        }
        .font(.default())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A11Y_SHAREDITEM")
        .accessibilityValue(item.a11y)
        .accessibilityValue(item.label)
      }

      init(_ item: SharedItem, project: SharedProject?) { (self.item, self.project) = (item, project) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedItemRowView_Previews: PreviewProvider {
  static var previews: some View {
    SharedItem.RowView.Render(.example, project: .example)

    List([SharedItem.example, .example, .example]) { item in SharedItem.RowView.Render(item, project: .example) }
      .previewDisplayName("List")
  }
}
#endif
