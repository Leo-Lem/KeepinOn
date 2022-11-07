//  Created by Leopold Lemmermann on 24.10.22.

import Combine
import Foundation

final class AppState: ObservableObject {
  let didChange = ObservableObjectPublisher()

  let routingService: RoutingService,
  @Published var settings = Settings()

  init(
    routingService: RoutingService? = nil,
  ) async {
    self.routingService = routingService ?? KORoutingService(keyValueService: self.keyValueService)
  #if DEBUG
    init(mocked: Void) {
      routingService = MockRoutingService(keyValueService: keyValueService)
    }
  #endif
  }
}

struct Settings: Codable {
}
