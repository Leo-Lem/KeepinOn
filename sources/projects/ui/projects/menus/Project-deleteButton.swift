// Created by Leopold Lemmermann on 08.12.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI

extension Project {
  func deleteButton(dismissOnDelete: Bool = false) -> some View {
    DeleteButton(self, dismissOnDelete: dismissOnDelete)
  }
  
  struct DeleteButton: View {
    let project: Project
    let dismissOnDelete: Bool
    
    var body: some View {
      AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) {
        isDeleting = true
        while isDeleting { await sleep(for: .nanoseconds(1000)) }
      } label: {
        Label("DELETE_PROJECT", systemImage: "xmark.octagon")
      }
      .tint(.red)
      .alert("DELETE_PROJECT_ALERT_TITLE", isPresented: $isDeleting) {
        Button("DELETE", role: .destructive) {
          Task(priority: .userInitiated) { await deleteProject() }
        }
      } message: {
        Text("DELETE_PROJECT_ALERT_MESSAGE")
      }
    }
    
    @State private var isDeleting = false
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var projectsController: ProjectsController
    @EnvironmentObject private var communityController: CommunityController
    
    init(_ project: Project, dismissOnDelete: Bool = false) {
      self.project = project
      self.dismissOnDelete = dismissOnDelete
    }
    
    @MainActor private func deleteProject() async {
      await printError {
        await printError {
          try await communityController.databaseService.delete(SharedProject.self, with: project.id)
        }
        
        for itemID in project.items {
          try await projectsController.databaseService.delete(Item.self, with: itemID)
        }
        try await projectsController.databaseService.delete(project)
      
        if dismissOnDelete { dismiss() }
      }
    }
  }
}
