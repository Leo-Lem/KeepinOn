//	Created by Leopold Lemmermann on 09.10.22.

import Concurrency
import Errors
import Foundation

extension EditProjectView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    private let project: Project

    @Published var isPublished: Bool?

    @Published var title: String
    @Published var details: String
    @Published var colorID: ColorID
    @Published private(set) var isClosed: Bool

    @Published var canSendReminders = false
    @Published var reminder: Date?

    @Published var user: User?

    init(_ project: Project, appState: AppState) {
      self.project = project

      title = project.title
      details = project.details
      isClosed = project.isClosed
      colorID = project.colorID
      reminder = project.reminder

      super.init(appState: appState)

      updateCanSendReminders()
      Task { await updateIsPublished() }
      updateUser()

      tasks.add(
        notificationService.didChange.getTask(operation: updateCanSendReminders),
        authService.didChange.getTask(operation: updateUser)
//        remoteDBService.didChange.getTask(with: updateIsPublished)
      )
    }
  }
}

extension EditProjectView.ViewModel {
  func toggleIsClosed() {
    isClosed.toggle()
    if isClosed { hapticsService?.play() }
    updateProject()
    routingService.route(to: isClosed ? Page.closed : Page.open)
  }

  func updateProject() {
    if reminder != nil {
      notificationService.schedule(.reminder(project))
    } else {
      notificationService.cancel(.reminder(project))
    }

    printError {
      try privDBService.insert(getUpdatedProject())
    }

    routingService.dismiss()
  }

  func requestDeletingProject() {
    routingService.route(
      to: .alert(
        .delete(
          project: project,
          fulfill: { [weak self] project in
            Task(priority: .userInitiated) {
              await self?.deleteProject(project)
            }
          }
        )
      )
    )
  }

  func publishProject() async {
    guard let user = user else { return routingService.route(to: Sheet.account) }

    await printError {
      try await appState.showErrorAlert {
        isPublished = nil
        let sharedProject = Project.Shared(getUpdatedProject(), owner: user.id)
        try await remoteDBService.publish(sharedProject)

        hapticsService?.play()

        let sharedItems = project.items.compactMap { id in
          printError {
            let item: Item? = try privDBService.fetch(with: id)
            return item.flatMap(Item.Shared.init)
          }
        }

        try await remoteDBService.publish(sharedItems)
      }
    }
  }

  func unpublishProject() async {
    guard user != nil else { return routingService.route(to: Sheet.account) }

    await printError {
      try await appState.showErrorAlert {
        isPublished = nil
        try await remoteDBService.unpublish(with: project.id, Project.Shared.self)
      }
    }
  }
}

private extension EditProjectView.ViewModel {
  func deleteProject(_ project: Project) async {
    await printError {
      if isPublished ?? false {
        try await appState.showErrorAlert {
          isPublished = nil
          try await remoteDBService.unpublish(with: project.id, Project.Shared.self)
        }
      }

      try privDBService.delete(project)

      routingService.dismiss()
    }
  }

  func updateCanSendReminders() {
    canSendReminders = notificationService.isAuthorized
  }

  func updateUser() {
    if case let .authenticated(user) = authService.status {
      self.user = user
    } else {
      user = nil
    }
  }

  func updateIsPublished() async {
    do {
      try await appState.showErrorAlert {
        isPublished = try await remoteDBService.exists(with: project.id, Project.Shared.self)
      }
    } catch {
      isPublished = nil
      print(error.localizedDescription)
    }
  }

  func getUpdatedProject() -> Project {
    var project = self.project

    project.title = title
    project.details = details
    project.isClosed = isClosed
    project.colorID = colorID
    project.reminder = reminder

    return project
  }
}