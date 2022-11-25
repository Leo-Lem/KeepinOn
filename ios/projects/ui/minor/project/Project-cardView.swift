//	Created by Leopold Lemmermann on 30.10.22.

import Errors
import SwiftUI

extension Project {
  func cardView() -> some View { Project.CardView(self) }
  
  struct CardView: View {
    let project: Project
    
    var body: some View {
      VStack(alignment: .leading) {
        Text("ITEMS \(project.items.count)")
          .font(.default(.caption1))
        
        Text(project.label)
          .font(.default(.title2))
        
        ProgressView(value: items.progress)
          .tint(project.color)
      }
      .padding()
      .background(Config.style.background)
      .cornerRadius(10)
      .shadow(color: .primary.opacity(0.2), radius: 5)
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("A11Y_COMPLETE_DESCRIPTION \(project.label) \(items.count) \(items.progress)")
    }
    
    @EnvironmentObject private var mainState: MainState
    
    init(_ project: Project) { self.project = project }
    
    private var items: [Item] {
      printError { try project.items.compactMap(mainState.localDBService.fetch) } ?? []
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectCard_Previews: PreviewProvider {
  static var previews: some View {
    Project.example.cardView()
      .previewDisplayName("Simple")
      .configureForPreviews()
  }
}
#endif
