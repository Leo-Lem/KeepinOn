//	Created by Leopold Lemmermann on 24.10.22.

import SwiftUI
import WidgetKit

struct SimpleWidget: Widget {
  let kind = "SimpleWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      EntryView(entry: entry)
    }
    .configurationDisplayName("WIDGET_TITLE")
    .description("WIDGET_SIMPLE_DESCRIPTION")
    .supportedFamilies([.systemSmall])
  }
}

extension SimpleWidget {
  struct EntryView: View {
    var entry: Provider.Entry

    var body: some View {
      VStack {
        Text("WIDGET_TITLE")
          .font(.default(.title1))

        Text(
          LocalizedStringKey(entry.itemsWithProject.first?.item.label ?? "WIDGET_PLACEHOLDER")
        )
      }
    }
  }
}

// MARK: - (Previews)

#if DEBUG
struct SimpleWidgetEntryView_Previews: PreviewProvider {
  static var previews: some View {
    SimpleWidget.EntryView(entry: .init(date: .now, itemsWithProject: [.example]))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
      .previewDisplayName("Small")
  }
}
#endif
