//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

extension Project {
  struct HeaderView: View {
    let id: Project.ID
    let canEdit: Bool

    var body: some View {
      WithConvertibleViewStore(
        with: id, from: \.privateDatabase.projects, loadWith: .init { .privateDatabase(.projects($0)) }
      ) { convertible in
        Unwrap(convertible) { (project: Project) in
          WithConvertiblesViewStore(
            matching: .init(\.project, id),
            from: \.privateDatabase.items, loadWith: .init { .privateDatabase(.items($0)) }
          ) { items in
            Render(project, canEdit: canEdit, items: items)
          }
        }
      }
    }

    struct Render: View {
      let project: Project
      let canEdit: Bool
      let items: [Item]
      let present: (MainDetail) -> Void

      var body: some View {
        HStack {
          #if os(iOS)
            VStack(alignment: .leading) {
              HStack {
                Text(project.label).lineLimit(1)

                Button { present(.project(id: project.id)) } label: {
                  Label("SHOW_PROJECT_DETAILS", systemImage: "info.bubble")
                }
                .accessibilityIdentifier("show-project-details")
              }

              ProgressView(value: items.progress)
            }
          #elseif os(macOS)
          Button { present(MainDetail.project(id: project.id)) } label: {
              Text(project.label).lineLimit(1)
              Spacer()
            }
            .buttonStyle(.borderless)
            .font(.default(.headline))
          #endif

          Spacer()

          Project.ToggleMenu(id: project.id, feedback: [])
            .accessibilityIdentifier("toggle-project")

          if canEdit {
            Button { present(.editProject(id: project.id)) } label: {
              Label("EDIT_PROJECT", systemImage: "square.and.pencil")
            }
            .accessibilityIdentifier("edit-project")
            .tint(.yellow)

            Project.DeleteMenu(id: project.id)
              .accessibilityIdentifier("delete-project")
          }
        }
        .labelStyle(.iconOnly)
        .tint(project.color)
        .padding(.bottom, 10)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(project.a11y(items))
      }

      init(_ project: Project, canEdit: Bool, items: [Item]) {
        (self.project, self.canEdit, self.items) = (project, canEdit, items)
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ProjectHeader_Previews: PreviewProvider {
    static var previews: some View {
      Form {
        Section { Text("some content (can edit)") } header: {
          Project.HeaderView.Render(.example, canEdit: true, items: [.example, .example, .example])
        }

        Section { Text("some more content (cannot edit)") } header: {
          Project.HeaderView.Render(.example, canEdit: false, items: [.example, .example, .example])
        }
      }
      .presentPreview()
    }
  }
#endif
