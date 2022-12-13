//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension SharedProject {
  func rowView() -> some View { SharedProject.RowView(self) }

  struct RowView: View {
    let project: SharedProject

    var body: some View {
      VStack(alignment: .leading) {
        Text(project.label)
          .font(.default(.headline))

        if let owner {
          Text(owner.label)
            .foregroundColor(owner.color)
        }
      }
      .accessibilityLabel("A11Y_SHAREDPROJECT")
      .accessibilityValue(project.a11y(owner?.label))
      .task {
        await loadOwner(for: project)
        tasks["updateOwner"] = communityController.databaseService.handleEventsTask(.userInitiated, with: updateOwner)
      }
      .onChange(of: project) { newProject in
        Task(priority: .userInitiated) { await loadOwner(for: newProject) }
      }
    }

    @Persisted private var owner: User?

    @EnvironmentObject private var communityController: CommunityController

    private let tasks = Tasks()

    init(_ project: SharedProject) {
      self.project = project
      _owner = Persisted(wrappedValue: nil, "\(project.id)-owner")
    }
  }
}

private extension SharedProject.RowView {
  @MainActor func loadOwner(for project: SharedProject) async {
    await printError {
      owner = try await communityController.databaseService.fetch(with: project.owner)
    }
  }

  @MainActor func updateOwner(on event: DatabaseEvent) async {
    switch event {
    case let .status(status) where status == .unavailable:
      break
    case let .inserted(type, id) where type == User.self && id as? User.ID == project.owner:
      await loadOwner(for: project)
    case let .deleted(type, id) where type == User.self && id as? User.ID == project.owner:
      owner = nil
    case .status, .remote:
      await loadOwner(for: project)
    default:
      break
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct SharedProjectRow_Previews: PreviewProvider {
  static var previews: some View {
    SharedProject.RowView(.example)
  }
}
#endif
