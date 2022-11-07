//  Created by Leopold Lemmermann on 09.10.22.

import Foundation

extension EditItemView {
  @MainActor final class ViewModel: KeepinOn.ViewModel {
    private let item: Item

    init(item: Item, appState: AppState) {
      self.item = item

      super.init(appState: appState)
    }
  }
}
