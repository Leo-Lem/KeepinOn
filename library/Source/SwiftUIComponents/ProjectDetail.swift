// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct ProjectDetail: View {
  let _project: Project.WithItems
  var project: Project { _project.project }
  var items: [Item] { _project.items }

  public var body: some View {
    VStack {
      HStack {
        Text(project.title)
          .font(.largeTitle)
          .fontWeight(.heavy)
          .lineLimit(1)

        Label(
          .localizable(project.closed ? .closed : .open),
          systemImage: project.closed ? "checkmark.diamond" : "diamond"
        )
        .labelStyle(.iconOnly)
        .font(.title)
        .fontWeight(.bold)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .foregroundColor(project.accent.color)
      .accessibilityAddTraits(.isHeader)
      .accessibilityIdentifier("project-detail-page-header")

      Text(project.details.replacing("\n", with: ""))
        .font(.title2)
        .fontWeight(.medium)

      ItemsProgress(items, accent: project.accent)
        .padding()

      ScrollView {
        ForEach(items, id: \.id) { item in
          ItemPeek(item, accent: project.accent)
        }
        .padding()
      }
      .border(.bar, width: 1)

      Spacer()

      Text(localizable: .createdAt(project.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? ""))
        .padding()
        .font(.subheadline)
    }
  }

  public init(_ project: Project.WithItems) { _project = project }
}

#Preview {
  @Previewable @State var presented = true

  Grid {}
    .sheet(isPresented: $presented) {
      ProjectDetail(.init(.example(), items: [.example(), .example()]))
    }
}
