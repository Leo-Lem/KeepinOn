//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import Errors
import LeosMisc
import Previews
import SwiftUI

extension Item {
  func detailView() -> some View { DetailView(self) }

  struct DetailView: View {
    let item: Item

    var body: some View {
      VStack {
        HStack {
          item.priority.icon
            .font(.default(.headline))
            .bold()

          Text(item.label)
            .font(.default(.largeTitle))
            .fontWeight(.heavy)

          Image(systemName: item.isDone ? "checkmark.circle" : "circle")
            .font(.default(.title1))
            .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(project?.color)
        .accessibilityAddTraits(.isHeader)
        .accessibilityIdentifier("item-detail-page-header")

        Text("\"\(item.detailsLabel)\"")
          .font(.default(.title2))
          .fontWeight(.medium)

        project?.cardView()
          .padding()

        Spacer()

        Text("CREATED_ON \(item.timestamp.formatted(date: .abbreviated, time: .shortened))")
          .padding()
          .font(.default(.subheadline))
      }
      #if os(iOS)
      .compactDismissButton()
      #endif
      .presentationDetents([.medium])
      .animation(.default, value: project)
      .task {
        await loadProject(of: item)
        tasks["updateProject"] = Task(priority: .background) { await updateProject() }
      }
      .onChange(of: item) { newItem in
        Task(priority: .userInitiated) { await loadProject(of: newItem) }
      }
    }
    
    @Persisted var project: Project?
    @State private var tasks = Tasks()
    @EnvironmentObject var mainState: MainState

    init(_ item: Item) {
      self.item = item
      
      _project = Persisted(wrappedValue: nil, "\(item)-project")
    }
  }
}

extension Item.DetailView {
  @MainActor func loadProject(of item: Item) async {
    await printError {
      project = try await mainState.privateDBService.fetch(with: item.project)
    }
  }
  
  @MainActor func updateProject() async {
    await printError {
      for await event in mainState.privateDBService.events {
        switch event {
        case let .inserted(type, id) where type == Project.self:
          if let id = id as? Project.ID, let project: Project = try await mainState.privateDBService.fetch(with: id) {
            self.project = project
          }
        case let .deleted(type, id) where type == Project.self && id as? Project.ID == item.project:
          project = nil
        case .remote:
          await loadProject(of: item)
        default:
          break
        }
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  struct ItemDetails_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Item.DetailView(.example)
          .previewDisplayName("Bare")

        Item.example.detailView()
          .previewInSheet()
          .previewDisplayName("Sheet")
      }
      .configureForPreviews()
    }
  }
#endif
