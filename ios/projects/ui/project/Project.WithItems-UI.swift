//	Created by Leopold Lemmermann on 09.11.22.

extension Project.WithItems {
  var progress: Double {
    guard !items.isEmpty else { return 0 }

    let completed = items.filter(\.isDone)
    return Double(completed.count) / Double(items.count)
  }
}
