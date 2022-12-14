//	Created by Leopold Lemmermann on 09.10.22.

import Concurrency
import DatabaseService
import Errors
import LeosMisc
import SwiftUI

extension Project {
  func headerView(canEdit: Bool, selectedDetail: Binding<Detail?>) -> some View {
    HeaderView(self, canEdit: canEdit, selectedDetail: selectedDetail)
  }

  struct HeaderView: View {
    @Binding var selectedDetail: Detail?
    let project: Project
    let canEdit: Bool

    var body: some View {
      HStack {
        #if os(iOS)
        VStack(alignment: .leading) {
          HStack {
            Text(project.label).lineLimit(1)
            AsyncButton { selectedDetail = .project(project) } label: {
              Label("SHOW_PROJECT_DETAILS", systemImage: "info.bubble")
                .accessibilityIdentifier("show-project-details")
            }
          }

          ProgressView(value: items.progress)
        }
        #elseif os(macOS)
        Button { selectedDetail = .project(project) } label: {
          Text(project.label).lineLimit(1)
          Spacer()
        }
        .buttonStyle(.borderless)
        .font(.default(.headline))
        #endif

        Spacer()

        project.toggleButton()
          .accessibilityIdentifier("toggle-project")

        if canEdit {
          AsyncButton { selectedDetail = .editProject(project) } label: {
            Label("EDIT_PROJECT", systemImage: "square.and.pencil")
              .accessibilityIdentifier("edit-project")
          }
          .tint(.yellow)

          project.deleteButton()
            .accessibilityIdentifier("delete-project")
        }
      }
      .labelStyle(.iconOnly)
      .tint(project.color)
      .padding(.bottom, 10)
      .accessibilityElement(children: .contain)
      .accessibilityLabel(project.a11y(items))
      .animation(.default, value: items)
      .task {
        await projectsController.loadItems(of: project, into: itemsBinding)
        tasks["updateItems"] = projectsController.databaseService.handleEventsTask(.background) { event in
          await projectsController.updateItems(of: project, on: event, into: itemsBinding)
        }
      }
      .onChange(of: project) { newProject in
        Task(priority: .userInitiated) { await projectsController.loadItems(of: newProject, into: itemsBinding) }
      }
    }

    @Persisted var items: [Item]
    private var itemsBinding: Binding<[Item]> { Binding(get: { items }, set: { items = $0 }) }
    
    @Environment(\.dismiss) var dismiss

    private let tasks = Tasks()

    @EnvironmentObject var projectsController: ProjectsController

    init(_ project: Project, canEdit: Bool, selectedDetail: Binding<Detail?>) {
      self.project = project
      self.canEdit = canEdit
      _selectedDetail = selectedDetail
      _items = Persisted(wrappedValue: [], "\(project.id)-items")
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct ProjectHeader_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Detail?.none) { binding in
      Form {
        Section {
          Text("some content (can edit)")
        } header: {
          Project.HeaderView(.example, canEdit: true, selectedDetail: binding)
        }

        Section {
          Text("some more content (cannot edit)")
        } header: {
          Project.example.headerView(canEdit: false, selectedDetail: binding)
        }
      }
    }
    
  }
}
#endif
