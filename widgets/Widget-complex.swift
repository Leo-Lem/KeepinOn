//	Created by Leopold Lemmermann on 24.10.22.

import SwiftUI
import WidgetKit

struct ComplexWidget: Widget {
  let kind = "ComplexWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      EntryView(entry: entry)
    }
    .configurationDisplayName("WIDGET_TITLE")
    .description("WIDGET_COMPLEX_DESCRIPTION")
  }
}

extension ComplexWidget {
  struct EntryView: View {
    let entry: Provider.Entry

    var body: some View {
      VStack(spacing: 5) {
        if itemsWithProject.isEmpty {
          Text("WIDGET_PLACEHOLDER")
        } else {
          ForEach(itemsWithProject) { itemWithProject in
            let item = itemWithProject.item,
                project = itemWithProject.project
            
            HStack {
              project.color
                .frame(width: 5)
                .clipShape(Capsule())

              VStack(alignment: .leading) {
                Text(item.label)
                  .font(.default(.headline))
                  .layoutPriority(1)

                Text(project.label)
                  .foregroundColor(.secondary)
              }

              Spacer()
            }
          }
          .padding(20)
        }
      }
    }

    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.sizeCategory) var sizeCategory

    private var itemsWithProject: ArraySlice<Item.WithProject> {
      entry.itemsWithProject.prefix({
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

// MARK: - (Previews)

struct ComplexWidgetEntryView_Previews: PreviewProvider {
  static var previews: some View {
    ComplexWidget.EntryView(
      entry: .init(date: .now, itemsWithProject: [.example, .example, .example])
    )
    .previewContext(WidgetPreviewContext(family: .systemSmall))
    .previewDisplayName("Small")

    ComplexWidget.EntryView(
      entry: .init(date: .now, itemsWithProject: [.example, .example, .example])
    )
    .previewContext(WidgetPreviewContext(family: .systemMedium))
    .previewDisplayName("Medium")

    ComplexWidget.EntryView(
      entry: .init(date: .now, itemsWithProject: [.example, .example, .example])
    )
    .previewContext(WidgetPreviewContext(family: .systemLarge))
    .previewDisplayName("Large")
  }
}
