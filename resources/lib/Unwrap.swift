// Created by Leopold Lemmermann on 25.12.22.

import SwiftUI

struct Unwrap<T, Content: View>: View {
  let optional: T?
  let content: (T) -> Content
  let soft: Bool
  
  var body: some View {
    if let unwrapped = optional { content(unwrapped) } else {
      Text("")
        .onAppear {
          if soft { dismiss() } else { fatalError("Found nil while trying to unwrap optional.") }
        }
    }
  }
  
  @Environment(\.dismiss) private var dismiss
  
  init(_ optional: T?, soft: Bool = false, @ViewBuilder content: @escaping (T) -> Content) {
    (self.optional, self.soft, self.content) = (optional, soft, content)
  }
}
