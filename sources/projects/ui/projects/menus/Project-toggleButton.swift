// Created by Leopold Lemmermann on 08.12.22.

import LeosMisc
import SwiftUI
import Errors

extension Project {
  func toggleButton() -> some View { ToggleButton(self) }
  
  struct ToggleButton: View {
    let project: Project
    
    var body: some View {
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
        await printError {
          try await projectsController.databaseService.modify(Project.self, with: project.id) { mutable in
            mutable.isClosed.toggle()
          }
        }
      } label: {
        project.isClosed ?
          Label("REOPEN_PROJECT", systemImage: "lock.open") :
          Label("CLOSE_PROJECT", systemImage: "lock")
      }
      .disabled(project.isClosed && projectsController.projectsLimitReached && !iapController.fullVersionIsUnlocked)
    }
    
    @EnvironmentObject private var projectsController: ProjectsController
    @EnvironmentObject private var iapController: IAPController
    
    init(_ project: Project) { self.project = project }
  }
}
