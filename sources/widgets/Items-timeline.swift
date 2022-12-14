//	Created by Leopold Lemmermann on 24.10.22.

import WidgetKit

struct Provider: TimelineProvider {
  struct Entry: TimelineEntry {
    let date: Date, itemsWithProject: [Item.WithProject]
  }

  nonisolated func placeholder(in context: Context) -> Entry {
    Entry(date: .now, itemsWithProject: [Item.WithProject.example])
  }

  nonisolated func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    let entry = Entry(date: .now, itemsWithProject: [Item.WithProject.example])
    completion(entry)
  }

  nonisolated func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let entry = Entry(date: .now, itemsWithProject: service.receive())
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }
  
  private let service = WidgetController()
}
