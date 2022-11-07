//	Created by Leopold Lemmermann on 20.10.22.

protocol NotificationService: ObservableService {
  var isAuthorized: Bool { get }

  func schedule(_ notification: Notification)
  func cancel(_ notification: Notification)
}
