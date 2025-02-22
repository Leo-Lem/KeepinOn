// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct ItemDetail: View {
  let item: Item
  let project: Project

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
      .foregroundColor(project.accent.color)
      .accessibilityAddTraits(.isHeader)
      .accessibilityIdentifier("item-detail-page-header")

      Text(item.details.replacing("\n", with: ""))
        .font(.title2)
        .fontWeight(.semibold)

      Divider()
        .frame(width: 200)

//      project?.peekView()
//        .padding()

      Spacer()

      if let createdAt = item.createdAt {
        Text(localizable: .createdAt(createdAt.formatted(date: .abbreviated, time: .shortened)))
          .padding()
          .font(.subheadline)
      }
    }
    .presentationDetents([.medium])
  }

  public init(_ item: Item, project: Project) {
    self.item = item
    self.project = project
  }
}

#Preview {
  @Previewable @State var presented = true

  Grid {}
    .sheet(isPresented: $presented) {
      ItemDetail(
        Item(createdAt: .now, projectId: 0, title: "Item 1", details: "Details of the item", priority: .urgent),
        project: Project(title: "Project 1", details: "Project details", accent: .green)
      )
    }
}
