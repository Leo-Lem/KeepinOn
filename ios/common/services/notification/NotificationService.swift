//	Created by Leopold Lemmermann on 20.10.22.

import Combine

protocol NotificationService {
  var didChange: PassthroughSubject<Void, Never> { get }

  var isAuthorized: Bool { get }

  func schedule(_ notification: Notification)
  func cancel(_ notification: Notification)
}
