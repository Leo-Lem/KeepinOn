//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

extension Project {
  func headerView(canEdit: Bool) -> some View { HeaderView(self, canEdit: canEdit) }

  struct HeaderView: View {
    let project: Project
    let canEdit: Bool

    var body: some View {
      WithConvertiblesViewStore(
        matching: .init(\.project, project.id),
        from: \.privateDatabase.items,
        loadWith: .init { MainReducer.Action.privateDatabase(.items($0)) }
      ) { items in
        Render(project, canEdit: canEdit, items: items)
      }
    }

    init(_ project: Project, canEdit: Bool) { (self.project, self.canEdit) = (project, canEdit) }

    struct Render: View {
      let project: Project
      let canEdit: Bool
      let items: [Item]

      var body: some View {
        HStack {
          #if os(iOS)
            VStack(alignment: .leading) {
              HStack {
                Text(project.label).lineLimit(1)

                Button { present(MainDetail.project(project)) } label: {
                  Label("SHOW_PROJECT_DETAILS", systemImage: "info.bubble")
                }
                .accessibilityIdentifier("show-project-details")
              }

              ProgressView(value: items.progress)
            }
          #elseif os(macOS)
            Button { present(MainDetail.project(project)) } label: {
              Text(project.label).lineLimit(1)
              Spacer()
            }
            .buttonStyle(.borderless)
            .font(.default(.headline))
          #endif

          Spacer()

          Project.ActionMenu.toggle(project)
            .accessibilityIdentifier("toggle-project")

          if canEdit {
            Button { present(MainDetail.editProject(project)) } label: {
              Label("EDIT_PROJECT", systemImage: "square.and.pencil")
            }
            .accessibilityIdentifier("edit-project")
            .tint(.yellow)

            Project.ActionMenu.delete(project)
              .accessibilityIdentifier("delete-project")
          }
        }
        .labelStyle(.iconOnly)
        .tint(project.color)
        .padding(.bottom, 10)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(project.a11y(items))
      }

      @Environment(\.present) var present

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
