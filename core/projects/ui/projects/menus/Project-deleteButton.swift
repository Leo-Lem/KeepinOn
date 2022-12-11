// Created by Leopold Lemmermann on 08.12.22.

import LeosMisc
import SwiftUI

extension Project {
  func deleteButton() -> some View { DeleteButton(self) }
  
  struct DeleteButton: View {
    let project: Project
    
    var body: some View {
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
        await mainState.showPresentationAndAwaitDismiss(alert: .deleteProject(project))
      } label: {
        Label("DELETE_PROJECT", systemImage: "xmark.octagon")
      }
      .tint(.red)
    }
    
    @EnvironmentObject private var mainState: MainState
    
    init(_ project: Project) { self.project = project }
  }
}
