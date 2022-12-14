// Created by Leopold Lemmermann on 14.12.22.

import SwiftUI

extension SharedProject {
  func peekView() -> some View { PeekView(self) }
  
  struct PeekView: View {
    let project: SharedProject
    
    var body: some View {
      HStack {
        Project.StatusLabel(project.isClosed)
          .labelStyle(.iconOnly)
          .imageScale(.medium)
        
        VStack(alignment: .leading) {
          Text(project.label)
            .bold()
            .lineLimit(1)
            .foregroundColor(project.color)
          
          if !project.details.isEmpty {
            Text(project.details)
              .lineLimit(1)
              .foregroundColor(.secondary)
          }
        }
        .font(.default())
      }
    }
    
    init(_ project: SharedProject) { self.project = project }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedProjectPeekView_Previews: PreviewProvider {
  static var previews: some View {
    SharedProject.example.peekView()
  }
}
#endif
