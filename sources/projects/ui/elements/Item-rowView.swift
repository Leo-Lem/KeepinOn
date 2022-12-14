//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Item {
  func rowView() -> some View { RowView(self) }

  struct RowView: View {
    let item: Item

    var body: some View {
      WithConvertibleViewStore(
        with: item.project,
        from: \.privateDatabase.projects,
        loadWith: .init { MainReducer.Action.privateDatabase(.projects($0)) }
      ) { project in
        Render(item, project: project)
      }
    }

    init(_ item: Item) { self.item = item }
    
    struct Render: View {
      let item: Item
      let project: Project?
      
      var body: some View {
        HStack {
          Image(systemName: item.icon)
            .foregroundColor(project?.color)
          
          Text(item.label)
          
          Text(item.details)
            .lineLimit(1)
            .foregroundColor(.secondary)
        }
        .font(.default())
        .accessibilityLabel(item.a11y)
        .accessibilityValue(item.label)
      }
      
      init(_ item: Item, project: Project?) { (self.item, self.project) = (item, project) }
    }
  }
}

// MARK: - (Previews)

#if DEBUG
struct ItemRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Item.RowView.Render(.example, project: .example)
        
      List([Item.example, .example, .example]) { Item.RowView.Render($0, project: .example) }
        .previewDisplayName("List")
    }
    .presentPreview()
  }
}
#endif
