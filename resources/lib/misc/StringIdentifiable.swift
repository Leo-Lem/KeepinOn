//  Created by Leopold Lemmermann on 28.10.22.

public protocol StringIdentifiable {
  var stringID: String { get }
}

public extension StringIdentifiable where Self: Identifiable, ID == String {
  var stringID: String {
    id
  }
}

import Foundation

public extension StringIdentifiable where Self: Identifiable, ID == UUID {
  var stringID: String {
    id.uuidString
  }
}
