// Created by Leopold Lemmermann on 08.12.22.

import LeosMisc
import SwiftUI

extension Project {
  func toggleButton() -> some View { ToggleButton(self) }
  
  struct ToggleButton: View {
    let project: Project
    
    var body: some View {
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
        await mainState.toggleProjectIsClosed(project)
      } label: {
        project.isClosed ?
          Label("REOPEN_PROJECT", systemImage: "lock.open") :
          Label("CLOSE_PROJECT", systemImage: "lock")
      }
      .disabled(mainState.projectLimitReached && project.isClosed)
    }
    
    @EnvironmentObject private var mainState: MainState
    
    init(_ project: Project) { self.project = project }
  }
}
