// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct PriorityLabel: View {
  let priority: Priority

  public var body: some View {
    Label {
      Text(priority.label)
    } icon: {
      ZStack {
        ForEach(0 ..< priority.rawValue, id: \.self) { index in
          Image(systemName: "chevron.up").offset(y: Double(1 - index) * 6)
        }
      }
    }
  }

  public init(_ priority: Priority) { self.priority = priority }
}

#Preview {
  HStack(spacing: 10) {
    PriorityLabel(.flexible)
    PriorityLabel(.prioritized)
    PriorityLabel(.urgent)
  }
}
