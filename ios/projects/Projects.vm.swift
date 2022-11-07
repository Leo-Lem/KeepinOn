//  Created by Leopold Lemmermann on 09.10.2022.

import Foundation

extension ProjectsView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    let closed: Bool

    init(closed: Bool, appState: AppState) {
      self.closed = closed

      super.init(appState: appState)
    }
  }
}
