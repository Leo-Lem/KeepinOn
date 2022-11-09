//	Created by Leopold Lemmermann on 09.11.22.

extension Project {
  struct WithItems: Identifiable, Hashable, Codable {
    let project: Project,
        items: [Item]
    
    var id: UUID { project.id }
    
    init(_ project: Project, items: [Item]) {
      self.project = project
      self.items = items
    }
  }
}
