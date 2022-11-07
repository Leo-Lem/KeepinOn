//	Created by Leopold Lemmermann on 24.10.22.

extension Project.Shared {
  var label: String {
    String(localized: .init(title ??? "PROJECT_DEFAULTNAME"))
  }

  var ownerLabel: String {
    String(localized: .init(owner?.label ?? "ANONYMOUS_USER"))
  }
}
