// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct ItemDetail: View {
  let item: Item
  let project: Project.WithItems

  public var body: some View {
    VStack {
      HStack {
        PriorityLabel(item.priority)
          .labelStyle(.iconOnly)
          .font(.headline)
          .bold()

        Text(item.title)
          .font(.largeTitle)
          .fontWeight(.heavy)
          .lineLimit(1)

        Image(systemName: item.done ? "checkmark.circle" : "circle")
          .font(.title)
          .fontWeight(.bold)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .foregroundColor(project.project.accent.color)
      .accessibilityAddTraits(.isHeader)
      .accessibilityIdentifier("item-detail-page-header")

      Text(item.details.replacing("\n", with: " "))
        .font(.title2)
        .fontWeight(.semibold)

      Divider()
        .frame(width: 200)

      ProjectPeek(project)
        .padding()

      Spacer()

      if let createdAt = item.createdAt {
        Text(localizable: .createdAt(createdAt.formatted(date: .abbreviated, time: .shortened)))
          .padding()
          .font(.subheadline)
      }
    }
    .presentationDetents([.medium])
  }

  public init(_ item: Item, project: Project.WithItems) {
    self.item = item
    self.project = project
  }
}

#Preview {
  @Previewable @State var presented = true

  Grid {}
    .sheet(isPresented: $presented) {
      ItemDetail(.example(), project: .init(.example(), items: [.example(), .example(), .example()]))
    }
}
