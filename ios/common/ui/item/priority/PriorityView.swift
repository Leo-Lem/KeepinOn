//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

struct PriorityView: View {
  let priority: Item.Priority

  var body: some View {
    VStack {
      ForEach(0..<priority.rawValue, id: \.self) { _ in
        Image(systemName: "chevron.up")
          .padding(-10)
      }
    }
    .padding()
  }

  init(_ priority: Item.Priority) {
    self.priority = priority
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct PriorityView_Previews: PreviewProvider {
  static var previews: some View {
    PriorityView(.low).previewDisplayName("low")
    PriorityView(.mid).previewDisplayName("mid")
    PriorityView(.high).previewDisplayName("high")
  }
}
#endif
