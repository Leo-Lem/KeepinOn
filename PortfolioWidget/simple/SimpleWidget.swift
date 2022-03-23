//
//  SimpleWidget.swift
//  PortfolioWidgets
//
//  Created by Leopold Lemmermann on 14.03.22.
//

import SwiftUI
import WidgetKit

struct SimpleWidget: Widget {
    
    let kind: String = "SimplePortfolioWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName(~.widget(.title))
        .description(~.widget(.simpleDesc))
        .supportedFamilies([.systemSmall])
    }
    
}
