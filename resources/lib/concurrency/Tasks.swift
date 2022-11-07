//	Created by Leopold Lemmermann on 31.10.22.

class Tasks {
  private var tasks = [String: Task<Void, Never>]()

  deinit {
    for (_, task) in tasks { task.cancel() }
  }

  func add(_ tasks: Task<Void, Never>...) {
    for task in tasks {
      add(for: nil, task)
    }
  }

  func add(for key: String?, _ task: Task<Void, Never>) {
    tasks[key ?? ""]?.cancel()
    tasks[key ?? "Task\(tasks.count)"] = task
  }

  func remove(for key: String) {
    tasks[key]?.cancel()
    tasks.removeValue(forKey: key)
  }
}
