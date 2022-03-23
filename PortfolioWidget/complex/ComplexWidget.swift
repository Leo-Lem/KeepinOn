//
//  ComplexWidget.swift
//  PortfolioWidgets
//
//  Created by Leopold Lemmermann on 22.03.22.
//

import SwiftUI
import WidgetKit

struct ComplexWidget: Widget {
    
    let kind: String = "ComplexPortfolioWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName(~.widget(.title))
        .description(~.widget(.complexDesc))
    }
    
}
