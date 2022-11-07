//	Created by Leopold Lemmermann on 09.10.22.

import Foundation

extension EditProjectView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    private let project: Project

    init(_ project: Project, appState: AppState) {
      self.project = project

      super.init(appState: appState)
    }
  }
}
