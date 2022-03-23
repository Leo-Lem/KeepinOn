//
//  Items-Timeline.swift
//  PortfolioWidgets
//
//  Created by Leopold Lemmermann on 22.03.22.
//

import WidgetKit
import CoreData

struct Provider: TimelineProvider {
    
    struct Entry: TimelineEntry {
        let date: Date,
            items: [Item]
    }
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: .now, items: [.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(date: .now, items: [.example])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry(date: .now, items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    private func loadItems() -> [Item] {
        let dc = DataController()
        let request = dc.fetchRequestForTopItems(count: 5)
        let results = try? dc.results(for: request)
        let items = results?.map(Item.init)
        
        return items ?? []
    }
    
}
