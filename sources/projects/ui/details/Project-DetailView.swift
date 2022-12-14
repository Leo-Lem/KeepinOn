//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Project {
  func detailView() -> some View { Project.DetailView(self) }

  struct DetailView: View {
    let project: Project

    var body: some View {
      WithConvertiblesViewStore(
        matching: .init(\.project, project.id),
        from: \.privateDatabase.items,
        loadWith: .init { MainReducer.Action.privateDatabase(.items($0)) }
      ) { items in
        Render(project, items: items)
      }
    }

    init(_ project: Project) { self.project = project }

    struct Render: View {
      let project: Project
      let items: [Item]

      var body: some View {
        VStack {
          HStack {
            Text(project.label)
              .font(.default(.largeTitle))
              .fontWeight(.heavy)
              .lineLimit(1)

            project.statusLabel()
              .labelStyle(.iconOnly)
              .font(.default(.title1))
              .fontWeight(.bold)
          }
          .padding()
          .frame(maxWidth: .infinity)
          .foregroundColor(project.color)
          .accessibilityAddTraits(.isHeader)
          .accessibilityIdentifier("project-detail-page-header")

          Text("'\(project.detailsLabel.replacing("\n", with: ""))'")
            .font(.default(.title2))
            .fontWeight(.medium)

          ProgressView(value: items.progress)
            .tint(project.color)
            .padding()

          ScrollView {
            ForEach(items, content: Item.PeekView.init)
              .padding()
          }
          .border(.top, .bottom)

          Spacer()

          Text("CREATED_ON \(project.timestamp.formatted(date: .abbreviated, time: .shortened))")
            .padding()
            .font(.default(.subheadline))
        }
        #if os(iOS)
        .compactDismissButton()
        #endif
      }

      init(_ project: Project, items: [Item]) { (self.project, self.items) = (project, items) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectDetails_Previews: PreviewProvider {
  static var previews: some View {
    Project.DetailView.Render(.example, items: [.example, .example]).presentPreview(inContext: true)
  }
}
#endif
