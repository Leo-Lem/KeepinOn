//	Created by Leopold Lemmermann on 27.11.22.

import Foundation

extension AwardsServiceImpl {
  static func loadAllAwards() -> [Award] {
    do {
      if let url = Bundle.module.url(forResource: "Awards", withExtension: "json") {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Award].self, from: data)
      } else {
        fatalError("Failed to load awards from Bundle.")
      }
    } catch { fatalError("Failed to load awards from Bundle: \(error)") }
  }
}
