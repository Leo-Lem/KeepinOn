//	Created by Leopold Lemmermann on 24.10.22.

import WidgetKit

struct Provider: TimelineProvider {
  struct Entry: TimelineEntry {
    let date: Date, items: [Item]
  }

  nonisolated func placeholder(in context: Context) -> Entry {
    Entry(date: .now, items: [.example])
  }

  nonisolated func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    let entry = Entry(date: .now, items: [.example])
    completion(entry)
  }

  nonisolated func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
      let entry = Entry(date: .now, items: loadItems())
      let timeline = Timeline(entries: [entry], policy: .never)
      completion(timeline)
  }

  private let service = CDService()
  private func loadItems() -> [Item] {
    let query = Query<Item>([
      .init(\.isDone, .eq, false)!,
      .init(\.project?.isClosed, .eq, false)!
    ], compound: .and)
    return (try? service.fetch(query)) ?? []
  }
}
