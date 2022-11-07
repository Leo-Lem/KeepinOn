//	Created by Leopold Lemmermann on 25.10.22.

extension Query {
  struct Options {
    let maxItems: Int?

    init(maxItems: Int? = nil) {
      self.maxItems = maxItems
    }
  }
}
