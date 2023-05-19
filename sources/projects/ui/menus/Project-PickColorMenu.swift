// Created by Leopold Lemmermann on 20.12.22.

import Colors
import SwiftUI

extension Project {
  struct PickColorMenu: View {
    let id: Project.ID
    
    var body: some View {
      WithEditableConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { editable in
        Unwrap(editable.convertible) { (project: Project) in
          ColorID.SelectionMenu(Binding { project.colorID } set: { editable.send(.modify(\.colorID, $0)) })
            .accessibilityLabel("PROJECT_SELECT_COLOR")
            .animation(.none, value: project.colorID)
        }
      }
    }
  }
}
