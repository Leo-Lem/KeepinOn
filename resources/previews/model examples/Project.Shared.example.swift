//	Created by Leopold Lemmermann on 24.10.22.

extension Project.Shared: HasExample {
  static var example: Project.Shared {
    Project.Shared(.example, owner: .example)
  }
}
