//	Created by Leopold Lemmermann on 09.11.22.

protocol WidgetService {
  func provide(_ items: [Item.WithProject])
  func receive() -> [Item.WithProject]
}
