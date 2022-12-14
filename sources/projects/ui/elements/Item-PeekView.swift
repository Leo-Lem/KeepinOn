//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Item {
  func peekView() -> some View { PeekView(self) }
  
  struct PeekView: View {
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
        HStack(spacing: 20) {
          Image(systemName: item.icon)
            .font(.default(.title1))
            .imageScale(.large)
            .foregroundColor(project?.color)
            .accessibilityLabel(item.a11y)
            
          VStack(alignment: .leading) {
            Text(item.label)
              .lineLimit(1)
              .font(.default(.title2))
              .foregroundColor(.primary)
              
            if !item.details.isEmpty {
              Text(item.details)
                .lineLimit(1)
                .foregroundColor(.secondary)
            }
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Config.style.background)
        .cornerRadius(10)
        .shadow(color: project?.color ?? .primary, radius: 3)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(item.a11y)
        .accessibilityValue(item.label)
      }
      
      init(_ item: Item, project: Project?) { (self.item, self.project) = (item, project) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ItemCard_Previews: PreviewProvider {
  static var previews: some View {
    Item.PeekView.Render(.example, project: .example)
      .padding()
  }
}
#endif
