//	Created by Leopold Lemmermann on 24.10.22.

extension Item.Shared {
  var label: String {
    String(localized: .init(title ??? "ITEM_DEFAULTNAME"))
  }
}
