//	Created by Leopold Lemmermann on 09.10.22.

import AuthenticationService
import Concurrency
import Errors
import Foundation
import PushNotificationService
import RemoteDatabaseService

extension Project.EditingView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    private let project: Project

    // view state
    @Published var isAuthenticating = false
    @Published var isDeleting = false

    // meta
    @Published private(set) var isPublished: Bool?
    @Published private(set) var canSendReminders = false
    @Published private(set) var user: User?

    // project details
    @Published var title: String
    @Published var details: String
    @Published var colorID: ColorID
    @Published private(set) var isClosed: Bool
    @Published var reminder: Date?

    let dismiss: () -> Void

    init(_ project: Project, dismiss: @escaping () -> Void, mainState: MainState) async {
      self.project = project
      self.dismiss = dismiss

      title = project.title
      details = project.details
      isClosed = project.isClosed
      colorID = project.colorID
      reminder = project.reminder

      super.init(mainState: mainState)

      loadCanSendReminders()
      await loadIsPublished()
      user = mainState.user

      tasks.add(
        notificationService.didChange.getTask(operation: updateCanSendReminders),
        mainState.didChange.getTask(.high, operation: updateUser),
        remoteDBService.didChange.getTask(operation: updateIsPublished)
      )
    }
  }
}

extension Project.EditingView.ViewModel {
  func toggleIsClosed() {
    isClosed.toggle()
    updateProject()
    if isClosed { hapticsService?.play(.taDa) }
    mainState.didChange.send(.page(isClosed ? .closed : .open))
  }

  func updateProject() {
    printError {
      try localDBService.insert(getUpdatedProject())
    }
    
    if reminder != nil {
      Task(priority: .userInitiated) {
        await notificationService.schedule(KeepinOnNotification.reminder(project))
      }
    } else {
      notificationService.cancel(KeepinOnNotification.reminder(project))
    }

    dismiss()
  }

  func publishProject() async {
    guard let user = user else { return isAuthenticating = true }

    await printError {
      try await mainState.displayError {
        isPublished = nil
        let sharedProject = SharedProject(getUpdatedProject(), owner: user.id)
        try await remoteDBService.publish(sharedProject)

        hapticsService?.play(.taDa)

        let sharedItems = project.items.compactMap { id in
          printError {
            let item: Item? = try localDBService.fetch(with: id)
            return item.flatMap(SharedItem.init)
          }
        }

        try await remoteDBService.publish(sharedItems)
      }
    }
  }

  func unpublishProject() async {
    guard user != nil else { return isAuthenticating = true }

    await printError {
      try await mainState.displayError {
        isPublished = nil
        try await remoteDBService.unpublish(with: project.id, SharedProject.self)
      }
    }
  }

  func deleteProject() async {
    await printError {
      try await mainState.displayError {
        if (try? await remoteDBService.exists(with: project.id, SharedProject.self)) ?? false {
          try await remoteDBService.unpublish(with: project.id, SharedProject.self)
        }
      }

      try localDBService.delete(project)

      for itemID in project.items { try localDBService.delete(with: itemID, Item.self) }

      dismiss()
    }
  }
}

private extension Project.EditingView.ViewModel {
  func getUpdatedProject() -> Project {
    var project = self.project

    project.title = title
    project.details = details
    project.isClosed = isClosed
    project.colorID = colorID
    project.reminder = reminder

    return project
  }

  func loadCanSendReminders() {
    canSendReminders = notificationService.isAuthorized ?? false
  }

  func loadIsPublished() async {
    await printError {
      do {
        try await mainState.displayError {
          isPublished = try await remoteDBService.exists(with: project.id, SharedProject.self)
        }
      } catch {
        isPublished = nil
        throw error
      }
    }
  }

  func updateCanSendReminders(_ change: PushNotificationChange) {
    if case let .authorization(isAuthorized) = change {
      canSendReminders = isAuthorized
    }
  }

  func updateUser(_ change: MainState.Change) {
    if case let .user(user) = change {
      self.user = user
    }
  }

  func updateIsPublished(_ change: RemoteDatabaseChange) async {
    switch change {
    case let .published(convertible):
      if let project = convertible as? SharedProject {
        isPublished = self.project.id == project.id
      }
    case let .unpublished(id, type):
      if
        type == SharedProject.self,
        let id = id as? UUID,
        project.id == id
      {
        isPublished = false
      }
    case .status, .remote:
      await loadIsPublished()
    }
  }
}
