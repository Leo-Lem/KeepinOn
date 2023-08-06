// Created by Leopold Lemmermann on 06.08.23.

import SwiftUI
import SwiftData

@main
struct HabitsApp: App {
  var body: some Scene {
    WindowGroup {
      AppView()
    }
    .modelContainer(for: Habit.self)
  }
}
