//	Created by Leopold Lemmermann on 30.10.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI

extension Item {
  func cardView() -> some View { CardView(self) }
  
  struct CardView: View {
    let item: Item
    
    var body: some View {
      HStack(spacing: 20) {
        Image(systemName: item.icon)
          .font(.default(.title1))
          .imageScale(.large)
          .foregroundColor(project?.color)
          .accessibilityLabel(item.a11y)
        
        VStack(alignment: .leading) {
          Text(item.label)
            .font(.default(.title2))
            .foregroundColor(.primary)
          
          if !item.details.isEmpty {
            Text(item.details)
              .foregroundColor(.secondary)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background(Config.style.background)
      .cornerRadius(10)
      #if os(iOS)
      .shadow(color: project?.color ?? .primary, radius: 2)
      #endif
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(item.a11y)
      .accessibilityValue(item.label)
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

extension Item.CardView {
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
  struct ItemCard_Previews: PreviewProvider {
    static var previews: some View {
      Item.example.cardView()
        .previewDisplayName("Simple")
        .configureForPreviews()
    }
  }
#endif
