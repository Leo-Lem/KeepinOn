//	Created by Leopold Lemmermann on 27.10.22.

import Combine

@MainActor
class ViewModel: ObservableObject {
  let appState: AppState

  private(set) var tasks = Tasks()

  init(appState: AppState) {
    self.appState = appState

    tasks.add(for: "stateHook", self.appState.objectWillChange.getTask(with: update))
  }

  func update() {
    objectWillChange.send()
  }
}
