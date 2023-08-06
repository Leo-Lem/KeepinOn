// Created by Leopold Lemmermann on 06.08.23.

import Foundation
import SwiftData

@Model
final class Habit {
  let id = UUID()
  let timestamp = Date()

  var title: String
  var details: String? = nil

  init(_ title: String) {
    self.title = title
  }
}
