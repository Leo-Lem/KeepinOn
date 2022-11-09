//	Created by Leopold Lemmermann on 09.11.22.

extension Item {
  struct WithProject: Identifiable, Hashable, Codable {
    let item: Item,
        project: Project
    
    var id: UUID { item.id }
    
    init(_ item: Item, project: Project) {
      self.item = item
      self.project = project
    }
  }
}
