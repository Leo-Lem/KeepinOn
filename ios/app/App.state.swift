//  Created by Leopold Lemmermann on 24.10.22.

import Combine
import Foundation

final class AppState: ObservableObject {
  let didChange = ObservableObjectPublisher()

  let routingService: RoutingService,
      keyValueService: KeyValueService,
  @Published var settings = Settings()

  init(
    routingService: RoutingService? = nil,
    keyValueService: KeyValueService? = nil,
  ) async {
    self.keyValueService = keyValueService ?? UDService()
    self.routingService = routingService ?? KORoutingService(keyValueService: self.keyValueService)
    printError {
      settings ?= try self.keyValueService.fetchObject(for: "settings")
    }
  #if DEBUG
    init(mocked: Void) {
      keyValueService = MockKeyValueService()
      routingService = MockRoutingService(keyValueService: keyValueService)
    }
  #endif
  }
}

struct Settings: Codable {
}
