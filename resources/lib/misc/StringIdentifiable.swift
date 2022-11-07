//	Created by Leopold Lemmermann on 28.10.22.

import Foundation

protocol StringIdentifiable {
  var stringID: String { get }
}

extension StringIdentifiable where Self: Identifiable, ID == UUID {
  var stringID: String {
    id.uuidString
  }
}

extension StringIdentifiable where Self: Identifiable, ID == String {
  var stringID: String {
    id
  }
}
