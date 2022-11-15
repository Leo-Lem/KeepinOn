//	Created by Leopold Lemmermann on 20.10.22.

struct Purchase: Identifiable {
  let id: ID,
      name: String,
      desc: String,
      price: String,
      rawPrice: Double

  enum Result {
    case success, pending, cancelled, failed(Error? = nil)
  }

  // swiftlint:disable:next type_name
  enum ID: String, CaseIterable {
    case fullVersion = "LeoLem.KeepinOn.fullVersion"
  }
}
