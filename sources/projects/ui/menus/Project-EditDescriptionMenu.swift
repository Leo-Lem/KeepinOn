// Created by Leopold Lemmermann on 20.12.22.

import LeosMisc
import SwiftUI

extension Project {
  struct EditDescriptionMenu: View {
    let id: Project.ID
      
    var body: some View {
      WithEditableConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { editable in
        Unwrap(editable.convertible) { (project: Project) in
          Render(
            project: project,
            newTitle: Binding { project.title } set: { editable.send(.modify(\.title, $0)) },
            newDetails: Binding { project.details } set: { editable.send(.modify(\.details, $0)) }
          )
        }
      }
    }
      
    struct Render: View {
      let project: Project
      @Binding var newTitle: String
      @Binding var newDetails: String
        
      var body: some View {
        TextField(project.title ??? String(localized: "PROJECT_NAME_PLACEHOLDER"), text: $newTitle)
          .accessibilityLabel("A11Y_EDIT_PROJECT_NAME")
          .accessibilityIdentifier("edit-project-name")
          .onChange(of: project.title) { if newTitle != $0 { newTitle = "" } }
          
        TextField(project.details ??? String(localized: "PROJECT_DESCRIPTION_PLACEHOLDER"), text: $newDetails)
          .accessibilityLabel("A11Y_EDIT_PROJECT_DESCRIPTION")
          .accessibilityIdentifier("edit-project-description")
          .onChange(of: project.details) { if newDetails != $0 { newDetails = "" } }
      }
    }
  }
}
