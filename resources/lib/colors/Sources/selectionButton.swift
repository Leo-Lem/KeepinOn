//	Created by Leopold Lemmermann on 30.10.22.

import LeosMisc
import SwiftUI

@available(iOS 15, macOS 12, *)
public extension ColorID {
  func selectionButton(isSelected: Bool, select: @escaping () -> Void) -> some View {
    SelectionButton(self, isSelected: isSelected, select: select)
  }

  struct SelectionButton: View {
    let colorID: ColorID,
        isSelected: Bool,
        select: () -> Void

    public var body: some View {
      Button { select() } label: {
        Label(colorID.a11y, systemImage: "checkmark.circle")
          .labelStyle(.iconOnly)
          .imageScale(.large)
          .foregroundColor(isSelected ? .primary : .clear)
      }
      .buttonStyle(.borderless)
      .padding()
      .background { colorID.color }
      .aspectRatio(1 / 1, contentMode: .fill)
      .cornerRadius(10)
      .if(isSelected) { $0.accessibilityAddTraits(.isSelected) }
    }

    public init(_ colorID: ColorID, isSelected: Bool, select: @escaping () -> Void) {
      self.colorID = colorID
      self.isSelected = isSelected
      self.select = select
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
@available(iOS 15, macOS 12, *)
struct SelectColorButton_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(ColorID.allCases, id: \.self) { colorID in
          colorID.selectionButton(isSelected: .random()) {}
        }
      }
      .padding()
    }
  }
}
#endif
