//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Project {
  func peekView() -> some View { Project.PeekView(self) }

  struct PeekView: View {
    let project: Project

    var body: some View {
      WithConvertiblesViewStore(
        matching: .init(\.project, project.id),
        from: \.privateDatabase.items, loadWith: .init { .privateDatabase(.items($0)) }
      ) { items in
        Render(project, items: items)
      }
    }

    @State private var items = [Item]()

    init(_ project: Project) { self.project = project }

    struct Render: View {
      let project: Project
      let items: [Item]

      var body: some View {
        VStack(alignment: .leading) {
          Text("ITEMS \(project.items.count)")
            .font(.default(.caption1))
            .foregroundColor(.secondary)

          HStack(alignment: .bottom) {
            Text(project.label)
              .lineLimit(1)
              .font(.default(.title2))
              .foregroundColor(project.color)
           
            Text(project.details)
              .lineLimit(1)
              .font(.default(.subheadline))
              .foregroundColor(.secondary)
          }
          
          ProgressView(value: items.progress)
            .tint(project.color)
        }
        .padding()
        .background(Config.style.background)
        .cornerRadius(10)
        .shadow(color: project.color, radius: 3)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.a11y(items))
        .accessibilityValue(project.label)
      }

      init(_ project: Project, items: [Item]) { (self.project, self.items) = (project, items) }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectCard_Previews: PreviewProvider {
  static var previews: some View {
    Project.PeekView.Render(.example, items: [.example, .example, .example])
      .padding()
  }
}
#endif
