// Created by Leopold Lemmermann on 22.02.25.

import Data

public struct PriorityPicker: View {
  @Binding public var priority: Priority

  public var body: some View {
    Picker(.localizable(.pickPriority), selection: $priority) {
      ForEach(Priority.allCases, id: \.self) { priority in
        Text(priority.label)
          .tag(priority)
      }
    }
    .pickerStyle(.segmented)
    .labelsHidden()
  }

  public init(_ priority: Binding<Priority>) { _priority = priority }
}

#Preview {
  @Previewable @State var priority = Priority.flexible

  PriorityPicker($priority)
}
