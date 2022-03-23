//
//  SimpleWidget-EntryView.swift
//  PortfolioWidgets
//
//  Created by Leopold Lemmermann on 22.03.22.
//

import SwiftUI
import WidgetKit
import MySwiftUI

extension SimpleWidget {
    struct EntryView: View {
        
        var entry: Provider.Entry

        var body: some View {
            VStack {
                Text(~.widget(.title), font: .title)
                
                Text(entry.items.first?.title ?? (~.widget(.placeholder)).localize())
            }
        }
        
    }
}

#if DEBUG
// MARK: - (Previews)
struct SimpleWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleWidget.EntryView(entry: .init(date: .now, items: [.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
