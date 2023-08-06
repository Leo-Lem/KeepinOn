// Created by Leopold Lemmermann on 06.08.23.

import SwiftData
import SwiftUI

struct AppView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var habits: [Habit]

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(habits) { Habit in
          NavigationLink {
            Text("Habit at \(Habit.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
          } label: {
            Text(Habit.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
          }
        }
        .onDelete(perform: deleteHabits)
      }
      .toolbar {
        #if os(iOS)
          ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
          }
        #endif
        ToolbarItem {
          Button(action: addHabit) {
            Label("Add Habit", systemImage: "plus")
          }
        }
      }
    } detail: {
      Text("Select an Habit")
    }
  }
}

private extension AppView {
  func addHabit() {
    let newHabit = Habit("New Habit")
    modelContext.insert(newHabit)
  }

  func deleteHabits(offsets: IndexSet) {
    for index in offsets {
      modelContext.delete(habits[index])
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  #Preview {
    AppView()
      .modelContainer(for: Habit.self, inMemory: true)
  }
#endif
