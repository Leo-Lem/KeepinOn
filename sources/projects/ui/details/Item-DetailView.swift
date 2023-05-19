//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Item {
  struct DetailView: View {
    let id: Item.ID

    var body: some View {
      WithConvertibleViewStore(
        with: id,
        from: \.privateDatabase.items,
        loadWith: .init { MainReducer.Action.privateDatabase(.items($0)) }
      ) { item in
        Unwrap(item) { item in
          WithConvertibleViewStore(
            with: item.project,
            from: \.privateDatabase.projects,
            loadWith: .init { MainReducer.Action.privateDatabase(.projects($0)) }
          ) { project in
            Render(item, project: project)
          }
        }
      }
    }
    
    struct Render: View {
      let item: Item
      let project: Project?
      
      var body: some View {
        VStack {
          HStack {
            item.priorityLabel()
              .labelStyle(.iconOnly)
              .font(.default(.headline))
              .bold()
            
            Text(item.label)
              .font(.default(.largeTitle))
              .fontWeight(.heavy)
              .lineLimit(1)
            
            Image(systemName: item.isDone ? "checkmark.circle" : "circle")
              .font(.default(.title1))
              .fontWeight(.bold)
          }
          .padding()
          .frame(maxWidth: .infinity)
          .foregroundColor(project?.color)
          .accessibilityAddTraits(.isHeader)
          .accessibilityIdentifier("item-detail-page-header")
          
          Text("'\(item.detailsLabel.replacing("\n", with: ""))'")
            .font(.default(.title2))
            .fontWeight(.medium)
          
          project?.peekView()
            .padding()
          
          Spacer()
          
          Text("CREATED_ON \(item.timestamp.formatted(date: .abbreviated, time: .shortened))")
            .padding()
            .font(.default(.subheadline))
        }
        .presentationDetents([.medium])
      }
      
      init(_ item: Item, project: Project?) { (self.item, self.project) = (item, project) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemDetails_Previews: PreviewProvider {
  static var previews: some View {
    Item.DetailView.Render(.example, project: .example)
      .presentPreview(inContext: true)
  }
}
#endif
