// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct ProjectPeek: View {
  let _project: Project.WithItems
  var project: Project { _project.project }
  var items: [Item] { _project.items }

  public var body: some View {
    VStack(alignment: .leading) {
      Text(localizable: .itemsLld(items.count))
        .font(.caption)
        .foregroundColor(.secondary)

      HStack(alignment: .bottom) {
        Text(project.title)
          .lineLimit(1)
          .font(.title2)
          .foregroundColor(project.accent.color)

        Text(project.details)
          .lineLimit(1)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }

      ItemsProgress(items, accent: project.accent)
    }
    .padding()
    .cornerRadius(10)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(project.a11y)
    .accessibilityValue(project.title)
  }

  public init(_ project: Project.WithItems) { _project = project }
}

#Preview {
  ProjectPeek(.init(.example(), items: [.example(), .example(), .example()]))
}
