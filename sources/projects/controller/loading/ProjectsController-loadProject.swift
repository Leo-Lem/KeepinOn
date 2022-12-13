// Created by Leopold Lemmermann on 14.12.22.

import DatabaseService
import Errors
import SwiftUI

extension ProjectsController {
  @MainActor func loadProject(of item: Item, into project: Binding<Project?>) async {
    await printError {
      project.wrappedValue = try await databaseService.fetch(with: item.project)
    }
  }

  @MainActor func updateProject(of item: Item, on event: DatabaseEvent, into project: Binding<Project?>) async {
    await printError {
      switch event {
      case let .inserted(type, id) where type == Project.self:
        if let id = id as? Project.ID, let newProject: Project = try await databaseService.fetch(with: id) {
          project.wrappedValue = newProject
        }
      case let .deleted(type, id) where type == Project.self && id as? Project.ID == item.project:
        project.wrappedValue = nil
      case .remote:
        await loadProject(of: item, into: project)
      default:
        break
      }
    }
  }
}
