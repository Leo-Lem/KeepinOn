//
//  ComplexWidget-EntryView.swift
//  PortfolioWidgets
//
//  Created by Leopold Lemmermann on 22.03.22.
//

import SwiftUI
import WidgetKit
import MySwiftUI

extension ComplexWidget {
    struct EntryView: View {
        
        let entry: Provider.Entry
        
        var body: some View {
            VStack(spacing: 5) {
                ForEach(items) { item in
                    HStack {
                        item.project?.colorID.color
                            .frame(width: 5)
                            .clipShape(.capsule)

                        VStack(alignment: .leading) {
                            Text(item.titleLabel, font: .headline)
                                .layoutPriority(1)

                            if let projectTitle = item.project?.titleLabel {
                                Text(projectTitle, color: .secondary)
                            }
                        }

                        Spacer()
                    }
                }
            }
            .padding(20)
        }
        
        @Environment(\.widgetFamily) var widgetFamily
        @Environment(\.sizeCategory) var sizeCategory
        
        private var items: ArraySlice<Item> {
            entry.items.prefix({
                switch widgetFamily {
                case .systemSmall: return 1
                case .systemMedium where sizeCategory < .extraLarge: return 3
                case .systemMedium: return 2
                case .systemLarge where sizeCategory < .extraExtraLarge: return 5
                case .systemLarge: return 4
                default: return 1
                }
            }())
        }
        
    }
}

#if DEBUG
// MARK: - (Previews)
struct ComplexWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ComplexWidget.EntryView(entry: .init(date: .now, items: [.example, .example, .example]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
