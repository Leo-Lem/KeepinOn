//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Item.Priority {
  var icon: some View { Icon(self) }
  
  struct Icon: View {
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
    
    init(_ priority: Item.Priority) { self.priority = priority }
  }
}

extension Item.Priority {
  var title: LocalizedStringKey {
    switch self {
    case .low: return "PRIORITY_LOW"
    case .mid: return "PRIORITY_MID"
    case .high: return "PRIORITY_HIGH"
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct PriorityView_Previews: PreviewProvider {
  static var previews: some View {
    Item.Priority.Icon(.low).previewDisplayName("low")
    Item.Priority.low.icon.previewDisplayName("mid")
    Item.Priority.Icon(.high).previewDisplayName("high")
  }
}
#endif
