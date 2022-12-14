//	Created by Leopold Lemmermann on 30.10.22.

import SwiftUI

extension Item.Priority {
  var titleKey: LocalizedStringKey {
    switch self {
    case .low: return "PRIORITY_LOW"
    case .mid: return "PRIORITY_MID"
    case .high: return "PRIORITY_HIGH"
    }
  }
}

extension Item.Priority {
  func label() -> some View { Item.PriorityLabel(self) }
}

extension Item {
  func priorityLabel() -> some View { PriorityLabel(priority) }

  struct PriorityLabel: View {
    let priority: Item.Priority

    var body: some View {
      Label {
        Text(priority.titleKey)
      } icon: {
        ZStack {
          ForEach(0 ..< priority.rawValue, id: \.self) { index in
            Image(systemName: "chevron.up").offset(y: Double(1 - index) * 6)
          }
        }
      }
    }

    init(_ priority: Item.Priority) { self.priority = priority }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
struct PriorityView_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Item.PriorityLabel(.low)
      Item.PriorityLabel(.mid)
      Item.PriorityLabel(.high)
    }
  }
}
#endif
