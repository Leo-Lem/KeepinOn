//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Project.WithItems {
  var detailsView: some View { Project.Details(self) }
}

extension Project {
  struct Details: View {
    let projectWithItems: Project.WithItems
    
    var body: some View {
      VStack {
        HStack {
          Text(project.label)
            .font(.default(.largeTitle))
            .fontWeight(.heavy)
          
          Image(systemName: project.isClosed ? "checkmark.diamond" : "diamond")
            .font(.default(.title1))
            .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(project.color)
        
        Text("\"\(project.detailsLabel)\"")
          .font(.default(.title2))
          .fontWeight(.medium)
        
        ProgressView(value: progress)
          .tint(project.color)
          .padding()
        
        ScrollView {
          ForEach(projectWithItems.revertRelationship(), content: Item.Card.init)
            .padding()
        }
        
        Spacer()
        
        Text("created on \(project.timestamp.formatted())")
          .padding()
          .font(.default(.subheadline))
      }
      .accessibilityLabel("A11Y_COMPLETE_DESCRIPTION \(project.label) \(itemsCount) \(progress)")
      .preferred(style: SheetViewStyle(dismissButtonStyle: .hidden))
    }
    
    private var project: Project { projectWithItems.project }
    private var progress: Double { projectWithItems.progress }
    private var itemsCount: Int { projectWithItems.items.count }
    
    init(_ projectWithItems: Project.WithItems) { self.projectWithItems = projectWithItems }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectDetails_Previews: PreviewProvider {
  static var previews: some View {
    Project.Details(.example)
      .previewDisplayName("Bare")

    SheetView.Preview {
      Project.WithItems.example.detailsView
    }
    .previewDisplayName("Sheet")
  }
}
#endif
