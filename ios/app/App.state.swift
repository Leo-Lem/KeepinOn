//  Created by Leopold Lemmermann on 24.10.22.

import Combine
import Foundation

final class AppState: ObservableObject {
  let didChange = ObservableObjectPublisher()

  @Published var settings = Settings()

  init(
  ) async {
  }
}

struct Settings: Codable {
}
