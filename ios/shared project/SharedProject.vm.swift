//	Created by Leopold Lemmermann on 25.10.22.

import Foundation

extension SharedProjectView {
  final class ViewModel: KeepinOn.ViewModel {
    let project: Project.Shared

    init(project: Project.Shared, appState: AppState) {
      self.project = project

      super.init(appState: appState)
    }
  }
}
